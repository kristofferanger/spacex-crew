//
//  CrewDetails.swift
//  SpaceXCrew
//
//  Created by Kristoffer Anger on 2023-08-22.
//

import SwiftUI

struct CrewDetails: View {
    
    @StateObject var viewModel: CrewDetailsViewModel
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct CrewDetails_Previews: PreviewProvider {
    static let crewMember = MockDataService.crewMember()
    static var previews: some View {
        CrewDetails(viewModel: CrewDetailsViewModel(crewMember: crewMember))
    }
}
