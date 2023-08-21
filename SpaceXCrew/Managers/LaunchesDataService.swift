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

}
