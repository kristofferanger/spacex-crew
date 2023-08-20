//
//  CrewList.swift
//  SpaceXCrew
//
//  Created by Kristoffer Anger on 2023-08-20.
//

import SwiftUI

struct CrewList: View {
    @StateObject private var viewModel = CrewViewModel(dataService: LaunchesDataService())

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.crew) { crewMember in
                    NavigationLink {
                        Text(crewMember.name)
                    } label: {
                        Text(crewMember.name)
                    }
                }
            }
            .onAppear{
                viewModel.loadCrew()
            }
            .navigationTitle("Launches")
            .navigationBarItems(leading: Image("SpaceXLogo").resizable().aspectRatio(contentMode: .fit).frame(maxWidth: 100).tint(Color("Inverted")))
        }
    }
}

struct CrewList_Previews: PreviewProvider {
    static var previews: some View {
        CrewList()
    }
}
