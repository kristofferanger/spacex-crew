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
                            
                for member in crew {
                    self?.addItem(member)
                }
                let request = NSFetchRequest<CrewMemberEntity>(entityName: "CrewMemberEntity")
                do {
                    try self?.crew = (self?.coreDataManager.context.fetch(request).map({ entity in
                        return CrewMember(id: entity.id!, name: entity.name!, agency: entity.agency!, launches: entity.launches!, image: entity.image, status: entity.status)
                    }))!
                }
                catch let error {
                    print("Error \(error)")
                }
                
                self?.crew = try! (self?.manager.context.fetch(request).map({ entity in
                    return CrewMember(id: entity.id!, name: entity.name!, agency: entity.agency!, launches: entity.launches!, image: entity.image, status: entity.status)}))!
                
                    
                
            }
            .store(in: &cancellables)
    }
    
    private func addItem(_ member: CrewMember) {
        
        var crewMember: CrewMemberEntity
        
        let request = NSFetchRequest<CrewMemberEntity>(entityName: "CrewMemberEntity")
        request.predicate = NSPredicate(format: "id == %@", member.id)
        if let result = try? manager.context.fetch(request), let entity = result.first {
            crewMember = entity
        }
        
        else {
            crewMember = CrewMemberEntity(context: manager.context)
            crewMember.id = member.id
        }
        
        crewMember.name = member.name
        crewMember.id = member.id
        crewMember.agency = member.agency
        crewMember.launches = member.launches
        crewMember.image = member.image
                
        manager.save()
    }
}
