//
//  ProfilesGridView.swift
//  GiftView
//
//  Created by Connor Hammond on 1/12/24.
//

import SwiftUI

struct ProfilesGridView: View {
    var profiles: [Profile]
    var viewModel: ProfilesViewModel
    @Binding var searchText: String
    
    let gridItems = [GridItem(), GridItem(), GridItem()]
    
    @Binding var path: [Profile]
    
    var body: some View {
        GeometryReader { geo in
            LazyVGrid(columns: gridItems, spacing: 25) {
                ForEach(searchText.isEmpty ? profiles : profiles.filter { $0.name.contains(searchText) }) { profile in
                    NavigationLink(value: profile) {
                        ProfileCardView(profile: profile, width: geo.size.width / 3.5, height: 115)
                    }
                    .navigationDestination(for: Profile.self) { profile in
                        ProfileDetailView(profile: profile, path: $path)
                    }
                }
            }
            .padding(.bottom)
            .padding(.horizontal)
        }
    }
}

#Preview {
    ProfilesGridView(profiles: ProfileMockData.shared.profiles,
                     viewModel: ProfilesViewModel(),
                     searchText: .constant(""),
                     path: .constant([]))
}
