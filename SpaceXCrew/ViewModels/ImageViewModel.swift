//
//  ImageViewModel.swift
//  SpaceXCrew
//
//  Created by Kristoffer Anger on 2023-08-22.
//

import Foundation
import SwiftUI
import Combine

class ImageViewModel: ObservableObject {
    
    @Published var image: UIImage? = nil
    @Published var isLoading: Bool = false
    
    private let dataService: ImageDataService
    private var cancellables = Set<AnyCancellable>()
    
    init(url: String?) {
        self.dataService = ImageDataService(url: url)
        self.addSubscribers()
        self.isLoading = true
    }
    
    private func addSubscribers() {
        dataService.$image
            .sink { [weak self] (_) in
                self?.isLoading = false
            } receiveValue: { [weak self] returnedImage in
                self?.image = returnedImage
            }
            .store(in: &cancellables)
        
    }
    
}
