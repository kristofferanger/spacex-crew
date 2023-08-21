//
//  CrewViewModel.swift
//  SpaceXCrew
//
//  Created by Kristoffer Anger on 2023-08-20.
//

import Foundation
import Combine
import SwiftUI
import CoreData

class CrewViewModel: ObservableObject {
        
    @Published var crew = [CrewMember]()
        
    init(dataService: CrewDataServiceProtocol) {
        self.crewDataService = dataService
        self.launchesDataService = LaunchesDataService()
        addSubscribers()
    }
    
    func loadCrew() {
        // delegate to data service to load data
        crewDataService.loadCrew()
        launchesDataService.loadLaunches()
    }
    
    // MARK: - private stuff
    private let coreDataManager = CoreDataManager.instance
    private let crewDataService: CrewDataServiceProtocol
    private let launchesDataService: LaunchesDataServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    private var activeFiltersIds = Set<Int>()

    // receive crew and launches
    private func addSubscribers() {
        crewDataService.crewPublisher.combineLatest(launchesDataService.launchesPublisher)
            .sink{ [weak self] crew, launches in
                // store/update crew
                self?.coreDataManager.fetchOrCreateEntities(ofType: CrewMemberEntity.self, matchingData: crew) { entity, crewMember in
                    crewMember.update(entity: entity)
                }
                // store/update launches
                self?.coreDataManager.fetchOrCreateEntities(ofType: LaunchEntity.self, matchingData: launches) { entity, launch in
                    launch.update(entity: entity)
                }
                                                            
                let request = NSFetchRequest<CrewMemberEntity>(entityName: "CrewMemberEntity")
                do {
                    try self?.crew = self?.coreDataManager.context.fetch(request).compactMap{ CrewMember(entity: $0) } ?? []
                }
                catch let error {
                    print("Error \(error)")
                }
            }
            .store(in: &cancellables)
    }
}
