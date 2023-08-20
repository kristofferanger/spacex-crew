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
