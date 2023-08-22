//
//  ImageDataService.swift
//  SpaceXCrew
//
//  Created by Kristoffer Anger on 2023-08-22.
//

import Foundation
import SwiftUI
import Combine

class ImageDataService {
    
    @Published var image: UIImage? = nil
    
    private var imageSubscription: AnyCancellable?
    private let fileManager = LocalFileManager.instance
    private let folderName = "spacex_images"
    private let imageName: String
    private let imageUrl: String?
    
    init(url: String?) {
        self.imageName = (url ?? "spacex").onlyLettersAndNumbers()
        self.imageUrl = url
        getImage()
    }
    
    private func getImage() {
        if let savedImage = fileManager.getImage(imageName: imageName, folderName: folderName) {
            image = savedImage
        } else {
            downloadImage()
        }
    }
    
    private func downloadImage() {
        guard let imageUrl, let url = URL(string: imageUrl) else { return }
        
        imageSubscription = NetworkingManager.download(url: url)
            .tryMap{ data in
                return UIImage(data: data)
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] returnedImage in
                guard let self = self, let downloadedImage = returnedImage else { return }
                self.image = downloadedImage
                self.imageSubscription?.cancel()
                self.fileManager.saveImage(image: downloadedImage, imageName: self.imageName, folderName: self.folderName)
            })
    }
    
}
