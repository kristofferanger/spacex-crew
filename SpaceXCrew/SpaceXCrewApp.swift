//
//  SpaceXCrewApp.swift
//  SpaceXCrew
//
//  Created by Kristoffer Anger on 2023-08-20.
//

import SwiftUI

@main
struct SpaceXCrewApp: App {
    var body: some Scene {
        // current data services
        let launchesDataService = LaunchesDataService()
        let crewDataService = CrewDataService()
        
        WindowGroup {
            CrewList(viewModel: CrewViewModel(crewDataService: crewDataService, launchesDataService: launchesDataService))
        }
    }
}
