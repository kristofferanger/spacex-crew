//
//  CrewList.swift
//  SpaceXCrew
//
//  Created by Kristoffer Anger on 2023-08-20.
//

import SwiftUI

struct CrewList: View {
    @StateObject var viewModel: CrewViewModel
    @State private var searchText = ""
    @State private var darkMode = false

    var body: some View {
        NavigationStack {
            SpinnerWhileLoadingView(viewModel.loadingStatus) {
                List {
                    ForEach(searchResults) { crewMember in
                        crewCell(member: crewMember, missions: viewModel.launchesFor(crewMember: crewMember))
                    }
                }
            } errorAlert: {
                return alert(error: $0)
            }
            .onAppear{
                if viewModel.lastDownload < Date(timeIntervalSinceNow: -300) {
                    viewModel.loadCrew()
                }
            }
            .navigationTitle("Crew")
            .navigationBarItems(leading: logo, trailing: lightDarkSwitch)
        }
        .searchable(text: $searchText)
        .preferredColorScheme(darkMode ? .dark : .light)
    }
    
    private func alert(error: Error) -> Alert {
        let alert = Alert(title: Text("Oops"), message: Text(error.localizedDescription), dismissButton: .default(Text("Retry")) {
            // try load items again on error dismiss
            viewModel.loadCrew()
        })
        return alert
    }

    private var lightDarkSwitch: some View {
        return Button {
            darkMode.toggle()
        } label: {
            Image(systemName: darkMode ? "sunrise.fill" : "sunset.fill")
        }
        .foregroundColor(Color("Inverted"))
    }
    
    private var logo: some View {
        return Image("SpaceXLogo")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(maxWidth: 100)
            .tint(Color("Inverted"))
    }
    
    private var searchResults: [CrewMember] {
        if searchText.isEmpty {
            return viewModel.crew
        }
        else {
            return viewModel.crew.filter { $0.name.lowercased().contains(searchText.lowercased()) || $0.agency.lowercased().contains(searchText.lowercased())
            }
        }
    }
    
    private func crewCell(member: CrewMember, missions: [Launch]) -> some View {
        NavigationLink {
            CrewDetails(viewModel: CrewDetailsViewModel(crewMember: member, launches: missions))
        } label: {
            VStack(alignment: .leading, spacing: 4) {
                Text(member.name)
                    .font(.headline)
                HStack {
                    Text("Missions: \(missions.count)")
                }
                .font(.caption)
            }
        }
        .padding(.vertical, 4)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct CrewList_Previews: PreviewProvider {
    static let launchesDataService = LaunchesDataService()
    static let crewDataService = CrewDataService()
    static var previews: some View {
        CrewList(viewModel: CrewViewModel(crewDataService: crewDataService, launchesDataService: launchesDataService))
    }
}
