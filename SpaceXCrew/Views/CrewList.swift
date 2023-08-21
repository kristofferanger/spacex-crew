//
//  CrewList.swift
//  SpaceXCrew
//
//  Created by Kristoffer Anger on 2023-08-20.
//

import SwiftUI

struct CrewList: View {
    @StateObject private var viewModel = CrewViewModel(dataService: LaunchesDataService())
    @State private var searchText = ""

    var body: some View {
        NavigationStack {
            List {
                ForEach(searchResults) { crewMember in
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
            .navigationTitle("Crew")
            .navigationBarItems(leading: logo)
        }
        .searchable(text: $searchText)
    }
    
    var logo: some View {
        return Image("SpaceXLogo")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(maxWidth: 100)
            .tint(Color("Inverted"))
    }
    
    var searchResults: [CrewMember] {
        if searchText.isEmpty {
            return viewModel.crew
        }
        else {
            return viewModel.crew.filter { $0.name.lowercased().contains(searchText.lowercased()) || $0.agency.lowercased().contains(searchText.lowercased())
            }
        }
    }
}

struct CrewList_Previews: PreviewProvider {
    static var previews: some View {
        CrewList()
    }
}
