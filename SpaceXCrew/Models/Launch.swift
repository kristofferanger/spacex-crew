//
//  Launch.swift
//  SpaceX-Launches
//
//  Created by Kristoffer Anger on 2023-08-19.
//

import Foundation

struct Launch: Codable, Identifiable {
    
    let id: String
    let name: String
    let success: Bool?
    let rocket: String?
    let details: String?
    let upcoming: Bool?
    let links: Links?
    
    struct Links: Codable {
        let webcast: String?
        let wikipedia: String?
        let flickr: Flickr?
    }
    
    struct Flickr: Codable {
        let original: [String]?
    }
}


// MARK: - Core data stuff
extension Launch {
    // for passing data to corresponding core data entity
    func update(entity: LaunchEntity) {
        entity.rocket = self.rocket
        entity.success = self.success ?? false
        entity.name = self.name
        entity.id = self.id
    }
    // demand that the non-optional properties
    // is not nil, ie: id, name
    // otherwise fail the init
    init?(entity: LaunchEntity) {
        guard let id = entity.id, let name = entity.name else { return nil }
        
        self.id = id
        self.name = name
        self.rocket = entity.rocket
        self.success = entity.success
        self.details = nil
        self.upcoming = nil
        self.links = nil
    }
    
}


