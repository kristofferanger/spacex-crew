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
    var crewPublisher: Published<Result<[CrewMember], Error>>.Publisher { get }
    // method to ask for updates
    func loadCrew()
}

class CrewDataService: CrewDataServiceProtocol {
    
    @Published var crew: Result<[CrewMember], Error> = .success([])

    var crewPublisher: Published<Result<[CrewMember], Error>>.Publisher { $crew }
    
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
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.crew = .failure(error)
                }
            }, receiveValue:{ [weak self] receiveValue in
                self?.crew = .success(receiveValue)
                self?.crewSubscription?.cancel()
            })
    }
}
