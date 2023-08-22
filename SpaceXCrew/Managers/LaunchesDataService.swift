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
    var launchesPublisher: Published<Result<[Launch], Error>>.Publisher { get }
    // method to ask for updates
    func loadLaunches()
}

class LaunchesDataService: LaunchesDataServiceProtocol {
  
    @Published var launches: Result<[Launch], Error> = .success([])
    @Published var error: Error? = nil
    
    var launchesPublisher: Published<Result<[Launch], Error>>.Publisher { $launches }
        
    init() {
        // load launches
        loadLaunches()
    }
        
    func loadLaunches() {
        guard let url = NetworkingManager.api.url(endpoint: "/launches") else { return }
        launchesSubscription = NetworkingManager.download(url: url)
            .decode(type: [Launch].self, decoder: NetworkingManager.defaultDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.launches = .failure(error)
                }
            }, receiveValue: { [weak self] value in
                self?.launches = .success(value)
                self?.launchesSubscription?.cancel()
            })
    }
    
    private var launchesSubscription: AnyCancellable?
}
