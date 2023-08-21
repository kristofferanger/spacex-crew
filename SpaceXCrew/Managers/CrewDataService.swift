//
//  CrewDataService.swift
//  SpaceXCrew
//
//  Created by Kristoffer Anger on 2023-08-21.
//

import Foundation
import Combine

protocol CrewDataServiceProtocol {
    // subscribe vars
    var crewPublisher: Published<[CrewMember]>.Publisher { get }
    // method to ask for updates
    func loadCrew()
}

class CrewDataService: CrewDataServiceProtocol {
    
    @Published var crew: [CrewMember] = []

    var crewPublisher: Published<[CrewMember]>.Publisher { $crew }
    
    private var crewSubscription: AnyCancellable?
    
    init() {
        // load crew
        loadCrew()
    }
    
    func loadCrew() {
        guard let url = NetworkingManager.api.url(endpoint: "/crew") else { return }
        crewSubscription = NetworkingManager.download(url: url)
            .decode(type: [CrewMember].self, decoder: NetworkingManager.defaultDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] crew in
                self?.crew = crew
                self?.crewSubscription?.cancel()
            })
    }
}
