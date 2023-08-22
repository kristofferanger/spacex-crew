//
//  CrewDetailsViewModel.swift
//  SpaceXCrew
//
//  Created by Kristoffer Anger on 2023-08-22.
//

import Foundation

class CrewDetailsViewModel: ObservableObject {
    
    @Published var crewMember: CrewMember
    @Published var launches: [Launch]
    
    init(crewMember: CrewMember, launches: [Launch]) {
        self.crewMember = crewMember
        self.launches = launches
    }
    
}
