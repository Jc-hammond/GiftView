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
            
    let makeAWishTip = MakeAWishTip()
    
    let colors = [Color.orange, Color.orange, Color.yellow, Color.clear]
    
    @State private var path: [Profile] = []
        
    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                Color(.background).ignoresSafeArea()
                
                VStack {
                    #if os(iOS)
                    TipView(makeAWishTip, arrowEdge: .top)
                        .padding(.horizontal)
                    #endif
                    
                    ScrollView {
                        if profiles.count > 0 {
                            ProfilesGridView(profiles: profiles,
                                             viewModel: viewModel,
                                             searchText: $viewModel.searchText,
                                             path: $path)
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
                    
                    SearchBar(text: $viewModel.searchText)
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
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $viewModel.isPickerPresented) {
                ContactPickerView { contacts in
                    viewModel.createProfilesAndShowAddView(contacts: contacts)
                }
            }
            .sheet(isPresented: $viewModel.isProfilesListShowing) {
                TabView(selection: $viewModel.currentProfileIndex) {
                    ForEach(Array($viewModel.profilesToSave.enumerated()), id: \.element.id) { index, $profile in
                        AddProfileModalView(profile: $profile, onCommit: { modifiedProfile in
                            modelContext.insert(modifiedProfile)
                            
                            if viewModel.currentProfileIndex < viewModel.profilesToSave.count - 1 {
                                //TODO: Add a delay here or an animation
                                viewModel.increaseProfileIndex()
                            }
                            viewModel.dismissAddProfileModal(profile: modifiedProfile)
                        })
                        
                        .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .always))
                .onDisappear {
                    if !firstVisit {
                        reviewManager.setCount(count: profiles.count)
                        if reviewManager.canAskForReview() {
                            requestReview()
                        }
                    }
                }
            }
            .toolbar {
                if !myProfiles.isEmpty {
                    let myProfile = myProfiles[0]
                    ToolbarItem(placement: .cancellationAction) {
                        MyProfileToolbarView(myProfile: myProfile)
                    }
                } else {
                    ToolbarItem(placement: .cancellationAction) {
                        NavigationLink {
                            CreateMyProfileView(path: $path)
                        } label: {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundStyle(.buttonBlue)
                        }
                    }
                }
                
                ToolbarItem(placement: .principal) {
                    NavigationLink {
                        #if os(iOS)
                        WishKitView()
                        #endif
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
                            viewModel.toggleImportPicker()
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
}

