//
//  ContentView.swift
//  GiftView
//
//  Created by Connor Hammond on 8/13/23.
//

import SwiftUI
import SwiftData
import Contacts
import TipKit
import StoreKit

enum ImportSelection {
    case create
    case importNew
}

struct ProfilesView: View {
    @EnvironmentObject private var reviewManager: RequestReviewManager
    @Environment(\.modelContext) private var modelContext
    @Environment(\.requestReview) private var requestReview
    @AppStorage("firstProfileVisit") var firstVisit: Bool = true
    @Query private var profiles: [Profile]
    @Query private var myProfiles: [MyProfile]
    
    @StateObject private var viewModel = ProfilesViewModel()
    
    @State private var isEditSheetShowing = false
    
    @State var isEditable = false
    
    @State var searchText = ""
    
    @State var isPickerPresented = false
    
    @State private var currentProfileIndex = 0
    
    let makeAWishTip = MakeAWishTip()
    
    let colors = [Color.orange, Color.orange, Color.yellow, Color.clear]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.background).ignoresSafeArea()
                
                VStack {
                    TipView(makeAWishTip, arrowEdge: .top)
                        .padding(.horizontal)
                    
                    ScrollView {
                        if profiles.count > 0 {
                            ProfilesGridView(profiles: profiles,
                                             viewModel: viewModel,
                                             isEditable: $isEditable,
                                             searchText: $searchText)
                            .onAppear(perform: {
                                reviewManager.setCount(count: profiles.count)
                                
                                if reviewManager.canAskForReview() {
                                    requestReview()
                                }
                            })
                            .padding(.top, 15)
                        } else {
                            ContentUnavailableView(label: {
                                Label("Add a profile to get started", systemImage: "person.circle")
                            })
                            .padding(.top, 50)
                        }
                        
                    }
                    
                    Spacer()
                    
                    SearchBar(text: $searchText)
                        .background {
                            RoundedRectangle(cornerRadius: 0)
                                .clipShape(
                                    .rect(
                                        topLeadingRadius: 25,
                                        bottomLeadingRadius: 0,
                                        bottomTrailingRadius: 0,
                                        topTrailingRadius: 25
                                    )
                                )
                                .frame(height: 145)
                                .foregroundStyle(.searchBackground)
                                .offset(y: 15)
                        }
                    
                }
            }
            .alert("Delete \(viewModel.profileToDelete?.name ?? "N/A")?", isPresented: $viewModel.isDeleteModalShowing) {
                Button("Delete", role: .destructive) {
                    guard let profile = viewModel.profileToDelete else {
                        viewModel.isDeleteModalShowing = false
                        isEditable = false
                        return
                    }
                    deleteAndDismiss(profile: profile)
                    reviewManager.setCount(count: profiles.count)
                }
                
                Button("Cancel", role: .cancel) {
                    DispatchQueue.main.async {
                        isEditable = false
                        viewModel.isDeleteModalShowing = false
                    }
                }
            } message: {
                Text("You cannot undo this action.")
            }
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $isPickerPresented) {
                ContactPickerView { contacts in
                    viewModel.createProfilesAndShowAddView(contacts: contacts)
                }
            }
            .sheet(isPresented: $viewModel.isEditSheetShowing) {
                if let profile = viewModel.profileToEdit {
                    EditProfileView(profile: Binding.constant(profile))
                }
            }
            
            .sheet(isPresented: $viewModel.isProfilesListShowing) {
                TabView(selection: $currentProfileIndex) {
                    ForEach(Array($viewModel.profilesToSave.enumerated()), id: \.element.id) { index, $profile in
                        AddProfileModalView(profile: $profile, onCommit: { modifiedProfile in
                            modelContext.insert(modifiedProfile)
                            
                            if currentProfileIndex < viewModel.profilesToSave.count - 1 {
                                //TODO: Add a delay here or an animation
                                currentProfileIndex += 1
                            }
                            viewModel.dismissAddProfileModal(profile: modifiedProfile)
                        })
                        
                        .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .always))
                .onDisappear {
                    reviewManager.setCount(count: profiles.count)
                    if reviewManager.canAskForReview() {
                        requestReview()
                    }
                }
            }
            .toolbar {
                if !myProfiles.isEmpty {
                    let myProfile = myProfiles[0]
                    ToolbarItem(placement: .cancellationAction) {
                        NavigationLink {
                            MyProfileView(myProfile: myProfile)
                        } label: {
                            if let avatar = myProfile.avatar {
                                let uiImage = UIImage(data: avatar)
                                Image(uiImage: uiImage!)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 40, height: 40)
                                    .clipShape(Circle())
                            } else {
                                Image(systemName: "person.circle.fill")
                            }
                        }
                    }
                } else {
                    ToolbarItem(placement: .cancellationAction) {
                        NavigationLink {
                            CreateMyProfileView()
                        } label: {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .frame(width: 40, height: 40)
                        }
                    }
                }
                
                //TODO: implement edit via onLongPress and add Wiggle animation
//                if !profiles.isEmpty {
//                    ToolbarItem(placement: .cancellationAction) {
//                        Button {
//                            isEditable.toggle()
//                        } label: {
//                            Text(isEditable ? "Done" : "Edit")
//                                .fontDesign(.rounded)
//                                .bold()
//                                .foregroundStyle(.buttonBlue)
//                                .opacity(viewModel.isDeleteModalShowing ? 0.4 : 1)
//                        }
//                    }
//                }
                
                
                ToolbarItem(placement: .principal) {
                    NavigationLink {
                        WishKitView()
                    } label: {
                        Text("GiftView")
                            .font(.largeTitle)
                            .fontDesign(.rounded)
                            .bold()
                            .foregroundStyle(.titleText)
                        
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Menu {
                        NavigationLink {
                            AddProfileView()
                                .onDisappear {
                                    reviewManager.setCount(count: profiles.count)
                                    if reviewManager.canAskForReview() {
                                        requestReview()
                                    }
                                }
                        } label: {
                            HStack {
                                Image(systemName: "plus")
                                Text("Create New")
                            }
                        }
                        
                        Button {
                            isPickerPresented = true
                        } label: {
                            HStack {
                                Image(systemName: "plus.circle")
                                Text("Import from Contacts")
                            }
                        }
                        
                    } label: {
                        ZStack {
                            Circle()
                                .frame(width: 40, height: 40)
                                .foregroundStyle(.buttonBlue)
                            Image(systemName: "plus")
                                .foregroundStyle(.accentBlue)
                        }
                        .opacity(viewModel.isDeleteModalShowing ? 0.4 : 1)
                    }
                }
            }
            .task {
                try? Tips.configure([
                    .displayFrequency(.immediate),
                    .datastoreLocation(.applicationDefault)])
            }
        }
    }
    
    
    private func deleteItems(offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(profiles[index])
        }
    }
    
    private func deleteAndDismiss(profile: Profile) {
        DispatchQueue.main.async {
            viewModel.profileToDelete = nil
            viewModel.isDeleteModalShowing = false
            modelContext.delete(profile)
        }
    }
}

