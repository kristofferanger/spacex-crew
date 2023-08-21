//
//  Rocket.swift
//  SpaceX-Launches
//
//  Created by Kristoffer Anger on 2023-08-19.
//

import Foundation

// simplyfied rocket struct with
// name as a calculated property
struct Rocket {

    static func name(id: String) -> String {
        switch id {
        case "5e9d0d95eda69955f709d1eb":
            return "Falcon 1"
        case "5e9d0d95eda69973a809d1ec":
            return "Falcon 9"
        case "5e9d0d95eda69974db09d1ed":
            return "Falcon Heavy"
        case "5e9d0d96eda699382d09d1ee":
            return "Starship"
        default:
            return "Unknown"
        }
    }
}
