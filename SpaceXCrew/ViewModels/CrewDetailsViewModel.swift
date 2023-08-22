//
//  CrewDetailsViewModel.swift
//  SpaceXCrew
//
//  Created by Kristoffer Anger on 2023-08-22.
//

import Foundation

class CrewDetailsViewModel: ObservableObject {
    
    @Published var crewMember: CrewMember
    
    init(crewMember: CrewMember) {
        self.crewMember = crewMember
    }
    
}
