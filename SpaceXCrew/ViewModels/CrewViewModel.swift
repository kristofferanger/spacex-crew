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
    
    let manager = CoreDataManager.instance
    
    @Published var crew = [CrewMember]()
        
    init(dataService: LaunchesDataServiceProtocol) {
        self.crewDataService = dataService
        addSubscribers()
    }
    
    func loadCrew() {
        crewDataService.loadCrew()
    }
    
    // MARK: - private stuff
    private let crewDataService: LaunchesDataServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    private var activeFiltersIds = Set<Int>()

    // receive podpcasts and genres
    private func addSubscribers() {
        crewDataService.crewPublisher
            .sink{ [weak self] crew in
                // self?.crew = crew
                for member in crew {
                    self?.addItem(member)
                }
                let request = NSFetchRequest<CrewMemberEntity>(entityName: "CrewMemberEntity")
                do {
                    try self?.crew = (self?.manager.context.fetch(request).map({ entity in
                        return CrewMember(id: entity.id!, name: entity.name!, agency: entity.agency!, launches: entity.launches!, image: entity.image, status: entity.status)
                    }))!
                }
                catch let error {
                    print("Error \(error)")
                }
                
                    
                
            }
            .store(in: &cancellables)
    }
    
    private func addItem(_ member: CrewMember) {
        withAnimation {
            let newItem = CrewMemberEntity(context: manager.context)
            newItem.name = member.name
            newItem.id = member.id
            newItem.agency = member.agency
            newItem.launches = member.launches
            newItem.image = member.image
            manager.save()
        }
    }
}
