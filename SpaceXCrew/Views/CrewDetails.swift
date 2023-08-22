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
        ScrollView {
            VStack() {
                ImageView(crewMember: viewModel.crewMember)
                    .scaledToFill()
                    .frame(maxWidth: .infinity)
                    .frame(height: 360)
                    .clipShape(Rectangle())
                VStack(alignment: .leading) {
                    Text(viewModel.crewMember.agency)
                        .font(.headline)
                    List(viewModel.launches) { launch in
                        Text(launch.name)
                    }
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle(viewModel.crewMember.name)
    }
}

struct CrewDetails_Previews: PreviewProvider {
    static let crewMember = MockDataService.crewMember()
    static let launch = MockDataService.launch()
    static var previews: some View {
        CrewDetails(viewModel: CrewDetailsViewModel(crewMember: crewMember, launches: [launch]))
    }
}
