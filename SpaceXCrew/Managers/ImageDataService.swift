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
    private let member: CrewMember
    private let fileManager = LocalFileManager.instance
    private let folderName = "spacex_images"
    private let imageName: String
    
    init(member: CrewMember) {
        self.member = member
        self.imageName = member.id
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
        guard let image = member.image, let url = URL(string: image) else { return }
        
        imageSubscription = NetworkingManager.download(url: url)
            .tryMap{ (data) -> UIImage? in
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
