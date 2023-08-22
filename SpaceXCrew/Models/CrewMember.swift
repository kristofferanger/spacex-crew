//
//  CrewMember.swift
//  SpaceX-Launches
//
//  Created by Kristoffer Anger on 2023-08-19.
//

import Foundation

/*
 "name": "Robert Behnken",
 "agency": "NASA",
 "image": "https://imgur.com/0smMgMH.png",
 "wikipedia": "https://en.wikipedia.org/wiki/Robert_L._Behnken",
 "launches": [
 "5eb87d46ffd86e000604b388"
 ],
 "status": "active",
 "id": "5ebf1a6e23a9a60006e03a7a"
 */

struct CrewMember: Codable, Identifiable {
    let id: String
    let name: String
    let agency: String
    let launches: [String]
    let image: String?
    let status: String?
}

// MARK: - Core data stuff
extension CrewMember {
    // for passing data to corresponding core data entity
    func update(entity: CrewMemberEntity) {
        entity.id = self.id
        entity.name = self.name
        entity.agency = self.agency
        entity.launches = self.launches
        entity.image = self.image
    }
    
    // demand that the non-optional properties
    // is not nil, ie: id, name, agency, launches
    // otherwise fail the init
    init?(entity: CrewMemberEntity) {
        guard let id = entity.id, let name = entity.name, let agency = entity.agency, let launches = entity.launches else {
            print("Failed to init a crewMember!")
            return nil
        }
        self.id = id
        self.name = name
        self.agency = agency
        self.launches = launches
        self.image = entity.image
        self.status = entity.status
    }
}
