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
    @Binding var isEditable: Bool
    @Binding var searchText: String
    
    let gridItems = [GridItem(), GridItem(), GridItem()]
    
    var body: some View {
        GeometryReader { geo in
            LazyVGrid(columns: gridItems, spacing: 25) {
                ForEach(searchText.isEmpty ? profiles : profiles.filter { $0.name.contains(searchText) }) { profile in
                    NavigationLink {
                        ProfileDetailView(profile: profile)
                    } label: {
                        ProfileCardView(profile: profile, width: geo.size.width / 3.5, height: 115, isEditable: $isEditable) { profile in
                            viewModel.prepareToDelete(profile: profile)
                            isEditable = false
                        }
                        .onLongPressGesture {
                            withAnimation {
                                isEditable = true
                            }
                        }
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
                     isEditable: .constant(false),
                     searchText: .constant(""))
}
