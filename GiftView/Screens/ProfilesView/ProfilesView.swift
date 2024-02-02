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
    
    @State var searchText = ""
    
    @State var isPickerPresented = false
    
    @State private var currentProfileIndex = 0
            
    let makeAWishTip = MakeAWishTip()
    
    let colors = [Color.orange, Color.orange, Color.yellow, Color.clear]
    
    @State private var path: [Profile] = []
        
    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                Color(.background).ignoresSafeArea()
                
                VStack {
                    TipView(makeAWishTip, arrowEdge: .top)
                        .padding(.horizontal)
                    
                    ScrollView {
                        if profiles.count > 0 {
                            ProfilesGridView(profiles: profiles,
                                             viewModel: viewModel,
                                             searchText: $searchText,
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
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $isPickerPresented) {
                ContactPickerView { contacts in
                    viewModel.createProfilesAndShowAddView(contacts: contacts)
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
                    if !firstVisit {
                        reviewManager.setCount(count: profiles.count)
                        if reviewManager.canAskForReview() {
                            requestReview()
                        }
                    }
                }
            }
            //TODO: Fix first navigation not working (bounces back)
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
                            CreateMyProfileView(path: $path)
                        } label: {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .frame(width: 40, height: 40)
                        }
                    }
                }
                
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
}

