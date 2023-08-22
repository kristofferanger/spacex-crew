//
//  CrewList.swift
//  SpaceXCrew
//
//  Created by Kristoffer Anger on 2023-08-20.
//

import SwiftUI

struct CrewList: View {
    @StateObject private var viewModel = CrewViewModel(dataService: CrewDataService())
    @State private var searchText = ""

    var body: some View {
        NavigationStack {
            List {
                ForEach(searchResults) { crewMember in
                    crewCell(member: crewMember, missions: viewModel.launchesFor(crewMember: crewMember))
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
    
    func crewCell(member: CrewMember, missions: [Launch]) -> some View {
        NavigationLink {
            Text(member.name)
        } label: {
            VStack(alignment: .leading, spacing: 4) {
                Text(member.name)
                HStack {
                    Text(member.agency)
                    Text("Missions: \(missions.filter{ $0.success == true }.count)")
                }
                .font(.caption)
            }
            
        }
        .padding(.vertical, 4)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct CrewList_Previews: PreviewProvider {
    static var previews: some View {
        CrewList()
    }
}
