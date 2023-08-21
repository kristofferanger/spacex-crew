//
//  LaunchesDataService.swift
//  SpaceX-Launches
//
//  Created by Kristoffer Anger on 2023-08-19.
//

import Foundation
import Combine

protocol LaunchesDataServiceProtocol {
    // subscribe vars
    var launchesPublisher: Published<[Launch]>.Publisher { get }
    // method to ask for updates
    func loadLaunches()
}

class LaunchesDataService: LaunchesDataServiceProtocol {
  
    @Published var launches: [Launch] = []
    var launchesPublisher: Published<[Launch]>.Publisher { $launches }
        
    init() {
        // load launches
        loadLaunches()
    }
        
    func loadLaunches() {
        guard let url = NetworkingManager.api.url(endpoint: "/crew") else { return }
        launchesSubscription = NetworkingManager.download(url: url)
            .decode(type: [Launch].self, decoder: NetworkingManager.defaultDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] value in
                self?.launches = value
                self?.launchesSubscription?.cancel()
            })
    }
    
    private var launchesSubscription: AnyCancellable?
    
    private func addItem<Item: Codable>(_ item: Item) {
        
        var crewMember: CrewMemberEntity
//
//        let request = NSFetchRequest<CrewMemberEntity>(entityName: "CrewMemberEntity")
//        request.predicate = NSPredicate(format: "id == %@", member.id)
//        if let result = try? coreDataManager.context.fetch(request), let entity = result.first {
//            crewMember = entity
//        }
//
//        else {
//            crewMember = CrewMemberEntity(context: coreDataManager.context)
//            crewMember.id = member.id
//        }
//
//        crewMember.name = member.name
//        crewMember.id = member.id
//        crewMember.agency = member.agency
//        crewMember.launches = member.launches
//        crewMember.image = member.image
//
//        coreDataManager.save()
    }

}
