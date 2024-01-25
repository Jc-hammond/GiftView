//
//  ProfileDetailView.swift
//  GiftView
//
//  Created by Connor Hammond on 8/14/23.
//

import SwiftUI
import SwiftData

struct ProfileDetailView: View {
    @Environment(\.modelContext) private var modelContext
    
    @StateObject var viewModel = ProfileDetailViewModel()
    
    @State var profile: Profile
    
    let gridItems = [GridItem(), GridItem(), GridItem()]
    
    var body: some View {
        ZStack {
            Color(.background).ignoresSafeArea()
            VStack {
                VStack {
                    if let imageData = profile.avatar {
                        let uiImage = UIImage(data: imageData)
                        Image(uiImage: uiImage!)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 150, height: 150)
                            .clipShape(Circle())
                        
                        
                    } else {
                        RoundedRectangle(cornerRadius: 25)
                            .frame(width: 150, height: 150)
                            .padding(.leading, 15)
                    }
                    
                    VStack(alignment: .center) {
                        Text(profile.name)
                            .foregroundStyle(.textBlue)
                            .font(.title)
                            .fontDesign(.rounded)
                            .bold()
                        
                        HStack(alignment: .center) {
                            Text(profile.birthdate, format: Date.FormatStyle(date: .abbreviated))
                                .font(.title2)
                                .foregroundStyle(.textBlue)
                                .fontDesign(.rounded)
                                .fontWeight(.semibold)
                            
                            Button {
                                Task {
                                    await viewModel.toggleNotifications(for: profile)
                                }
                            } label: {
                                Image(systemName: profile.hasNotifications ? "bell.fill" : "bell.slash.fill")
                                    .resizable()
                                    .frame(width: 18, height: 18)
                                    .foregroundStyle(.buttonBlue)
                            }
                            .alert(isPresented: $viewModel.isNotificationsAlertShowing) {
                                Alert(
                                    title: Text("Notifications Disabled"),
                                    message: Text("Please allow notifications to receive birthday reminders"),
                                    primaryButton: .default(
                                        Text("OK")
                                    ),
                                    secondaryButton: .cancel(
                                        Text("Go to Settings"),
                                        action: viewModel.goToSettings
                                    )
                                )
                            }
                        }
                        .padding(.leading, 10)
                        
                    }
                }
                
                VStack {
                    Group {
                        HStack(alignment: .center) {
                            Text("Gift Ideas")
                                .font(.title)
                                .foregroundStyle(.textBlue)
                                .fontDesign(.rounded)
                                .fontWeight(.semibold)
                                .padding(.leading, 15)
                            
                            Button {
                                viewModel.isAddGiftShowing = true
                            } label: {
                                Image(systemName: "plus.circle.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 25, height: 25)
                                    .foregroundStyle(.buttonBlue)
                            }
                            
                            Spacer()
                        }
                        
                        if let daysUntilBirthday = viewModel.daysUntilNextBirthday(from: profile.birthdate) {
                            HStack {
                                Text("\(daysUntilBirthday) days until \(profile.name)'s next birthday.")
                                    .fontDesign(.rounded)
                                    .foregroundStyle(.textBlue)
                                    .lineLimit(1)
                                    .padding(.leading, 15)
                                
                                Spacer()
                            }
                        } else {
                            Text("Unable to calculate days until next birthday.")
                                .fontDesign(.rounded)
                                .foregroundStyle(.textBlue)
                        }
                    }
                    
                    
                    if let gifts = profile.gifts {
                        Picker("", selection: $viewModel.isShowingImageList) {
                            Text("Images").tag("images")
                                .foregroundStyle(.textBlue)
                                .fontDesign(.rounded)
                            Text("Check List").tag("list")
                                .foregroundStyle(.textBlue)
                                .fontDesign(.rounded)
                        }
                        .pickerStyle(.segmented)
                        .padding(.horizontal)
                        .padding(.bottom)
                        
                        
                        if gifts.isEmpty{
                            ContentUnavailableView {
                                Label("Add gifts to get started", systemImage: "plus.circle")
                            }
                        } else {
                            if viewModel.isShowingImageList == "images" {
                                GiftsGridView(gifts: gifts) { gift in
                                    viewModel.selectedGift = gift
                                }
                            } else if viewModel.isShowingImageList == "list" {
                                GiftsChecklistView(gifts: gifts)
                                Spacer()
                            }
                        }
                    }
                }
            }
            .sheet(isPresented: $viewModel.isAddGiftShowing) {
                AddGiftView(profile: profile)
            }
            .sheet(item: $viewModel.selectedGift) { giftToDisplay in
                GiftDetailsView(gift: giftToDisplay)
            }
            
            .toolbar {
                ToolbarItem {
                    NavigationLink {
                        EditProfileView(profile: $profile)
                    } label: {
                        Text("Edit")
                            .fontDesign(.rounded)
                    }
                }
                
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
