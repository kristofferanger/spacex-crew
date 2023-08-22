//
//  ImageView.swift
//  SpaceXCrew
//
//  Created by Kristoffer Anger on 2023-08-22.
//

import SwiftUI

struct ImageView: View {
    
    @StateObject var viewModel: ImageViewModel
    
    init(url: String?) {
        self._viewModel = StateObject(wrappedValue: ImageViewModel(url: url))
    }
    
    var body: some View {
        ZStack {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
            }
            else if viewModel.isLoading {
                ProgressView()
            }
            else {
                Image(systemName: "questionmark")
                    .foregroundColor(Color.secondary)
            }
        }
    }
}

struct ImageView_Previews: PreviewProvider {
    static var previews: some View {
        ImageView(url: MockDataService.crewMember().image)
    }
}
