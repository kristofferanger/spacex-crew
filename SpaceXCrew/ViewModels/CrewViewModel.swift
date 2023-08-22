//
//  CrewViewModel.swift
//  SpaceXCrew
//
//  Created by Kristoffer Anger on 2023-08-20.
//

import Foundation
import Combine
import SwiftUI

class CrewViewModel: ObservableObject {
        
    @Published var crew = [CrewMember]()
    @Published var launches = [Launch]()
    @Published var loadingStatus: LoadingStatus = .unknown
        
    init(crewDataService: CrewDataServiceProtocol, launchesDataService: LaunchesDataServiceProtocol) {
        self.crewDataService = crewDataService
        self.launchesDataService = launchesDataService
        addSubscribers()
    }
    
    func loadCrew() {
        // delegate to data service to load data
        crewDataService.loadCrew()
        launchesDataService.loadLaunches()
        loadingStatus = .loading
    }
    
    func launchesFor(crewMember: CrewMember) -> [Launch] {
        return launches.filter{ crewMember.launches.contains($0.id) }
    }
    
    // MARK: - private stuff
    private let coreDataManager = CoreDataManager.instance
    private let crewDataService: CrewDataServiceProtocol
    private let launchesDataService: LaunchesDataServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    private var activeFiltersIds = Set<Int>()

    // receive crew and launches
    private func addSubscribers() {
        crewDataService.crewPublisher
            .combineLatest(launchesDataService.launchesPublisher)
            .sink {  [weak self] completion in
                if case .failure(let error) = completion {
                    self?.loadingStatus = .failed(error)
                }
            } receiveValue: { [weak self] crew, launches in
                guard let self else { return }
                // store/update crew
                self.coreDataManager.fetchOrCreateEntities(ofType: CrewMemberEntity.self, matchingData: crew) { entity, crewMember in
                    crewMember.update(entity: entity)
                }
                // store/update launches
                self.coreDataManager.fetchOrCreateEntities(ofType: LaunchEntity.self, matchingData: launches) { entity, launch in
                    launch.update(entity: entity)
                }
                // load crew and launches from DB
                self.launches = self.coreDataManager
                    .fetchEntities(ofType: LaunchEntity.self)
                    .compactMap{ Launch(entity: $0) }
                // update crew
                self.crew = self.coreDataManager
                    .fetchEntities(ofType: CrewMemberEntity.self)
                    .compactMap{ CrewMember(entity: $0) }
                    .sorted(by: { self.lastNameSorting(first: $0.name, second: $1.name) })
                // update loading status
                self.loadingStatus = .finished
            }
            .store(in: &cancellables)
    }
    
    private func lastNameSorting(first: String, second: String) -> Bool {
        guard let firstLastName = first.split(separator: " ").last, let secondLastname = second.split(separator: " ").last else { return false }
        return firstLastName < secondLastname
    }
}

// MARK: - Helper objects
enum LoadingStatus {
    case unknown, loading, finished, failed(Error)
}
