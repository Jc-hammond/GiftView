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
                    }
                }
            }
            .padding(.bottom)
            .padding(.horizontal)
        }
    }
}

struct ProfileDeleteModal: View {
    var onDismiss: () -> Void
    var profile: Profile
    var onDeleteConfirm: () -> Void
    
    @State var scale = 1.0
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
            VStack(spacing: 5) {
                Text("Delete \(profile.name)?")
                    .bold()
                    .font(.title2)
                    .fontDesign(.rounded)
                    .foregroundStyle(.textBlue)
                    .padding(.top)
                Text("You cannot undo this action")
                    .font(.body)
                    .fontDesign(.rounded)
                    .foregroundStyle(.textBlue)
                
                Image(systemName: "x.circle")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .foregroundStyle(.errorRed)
                    .padding(.top)
                
                HStack(spacing: 25) {
                    Button("Delete") {
                        print("tapped")
                        onDeleteConfirm()
                        
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.errorRed)
                    .controlSize(.large)
                    Button("Cancel") {
                        onDismiss()
                    }
                    .buttonStyle(.bordered)
                    .foregroundStyle(.buttonBlue)
                    .controlSize(.large)
                }
                .padding()
            }
            .frame(width: 300, height: 200)
            .background(Color.white)
            .cornerRadius(20).shadow(radius: 20)
            
        }
        
    }
}

#Preview {
    ProfilesGridView(profiles: ProfileMockData.shared.profiles,
                     viewModel: ProfilesViewModel(),
                     isEditable: .constant(false),
                     searchText: .constant(""))
}
