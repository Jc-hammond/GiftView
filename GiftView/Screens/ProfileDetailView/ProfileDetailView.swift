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
                        
                        Text(profile.birthdate, format: Date.FormatStyle(date: .abbreviated))
                            .font(.title2)
                            .foregroundStyle(.textBlue)
                            .fontDesign(.rounded)
                            .fontWeight(.semibold)
                                                
                    }
                    .padding(.leading, 15)
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
                                .padding(.top, 5)
                            
                            Button {
                                viewModel.toggleNotifications(for: profile)
                            } label: {
                                Image(systemName: profile.hasNotifications ? "bell.fill" : "bell.slash.fill")
                                    .resizable()
                                    .frame(width: 18, height: 18)
                                    .foregroundStyle(.buttonBlue)
                                    .padding(.top, 10)
                            }
                            .alert(isPresented: $viewModel.isNotificationsAlertShowing) {
                                Alert(
                                    title: Text("Notifications Disabled"),
                                    message: Text("Please allow notifications to receive birthday reminders"),
                                    primaryButton: .default(
                                        Text("Try Again")
                                    ),
                                    secondaryButton: .destructive(
                                        Text("Delete"),
                                        action: viewModel.goToSettings
                                    )
                                )
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
                        
                        if viewModel.isShowingImageList == "images" {
                            
                            
                            if gifts.count < 1 {
                                ContentUnavailableView {
                                    Label("Add gifts to get started", systemImage: "plus.circle")
                                }
                            } else {
                                ScrollView {
                                    LazyVGrid(columns: gridItems, spacing: 8) {
                                        ForEach(gifts.sorted(by: { $0.title < $1.title }), id: \.self) { gift in
                                            Button {
                                                viewModel.selectedGift = gift
                                            } label: {
                                                GiftCardView(gift: gift)
                                            }
                                        }
                                        
                                        Button {
                                            viewModel.isAddGiftShowing = true
                                        } label: {
                                            ZStack {
                                                RoundedRectangle(cornerRadius: 15)
                                                    .fill(.buttonBlue)
                                                    .frame(width: 110, height: 110)
                                                
                                                VStack {
                                                    Image(systemName: "plus")
                                                        .tint(.white)
                                                        .fontWeight(.semibold)
                                                    Text("Add gift")
                                                        .fontWeight(.semibold)
                                                        .fontDesign(.rounded)
                                                        .tint(.white)
                                                        .padding(.top, 10)
                                                }
                                            }
                                        }
                                    }
                                    .padding(.horizontal, 10)
                                }
                            }
                            
                        } else if viewModel.isShowingImageList == "list" {
                            if gifts.count < 1 {
                                ContentUnavailableView {
                                    Label("Add gifts to get started", systemImage: "plus.circle")
                                }
                            } else {
                                List {
                                    Section(header: Text("Not Purchased")) {
                                        ForEach(gifts.filter { !$0.isPurchased }, id: \.title) { gift in
                                            HStack {
                                                Text(gift.title)
                                                    .foregroundStyle(.textBlue)
                                                    .fontDesign(.rounded)
                                                Spacer()
                                                Button {
                                                    gift.isPurchased.toggle()
                                                } label: {
                                                    Image(systemName: gift.isPurchased ? "checkmark.circle.fill" : "checkmark.circle")
                                                        .tint(Color.white)
                                                }
                                            }
                                        }
                                    }
                                    
                                    Section(header: Text("Purchased")) {
                                        ForEach(gifts.filter { $0.isPurchased }, id: \.title) { gift in
                                            HStack {
                                                Text(gift.title)
                                                    .foregroundStyle(.textBlue)
                                                    .fontDesign(.rounded)
                                                Spacer()
                                                Button {
                                                    gift.isPurchased.toggle()
                                                } label: {
                                                    Image(systemName: gift.isPurchased ? "checkmark.circle.fill" : "checkmark.circle")
                                                        .tint(Color.white)
                                                }
                                            }
                                        }
                                    }
                                }
                                .listStyle(.plain)
                                
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
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        viewModel.isAddGiftShowing = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
                
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
