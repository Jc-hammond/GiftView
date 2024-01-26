//
//  MyProfileView.swift
//  GiftView
//
//  Created by Connor Hammond on 1/22/24.
//

import SwiftUI

struct MyProfileView: View {
    @StateObject var viewModel = MyProfileViewModel()
    
    @State var myProfile: MyProfile
        
    var body: some View {
        ZStack {
            Color(.background).ignoresSafeArea()
            
            VStack {
                if let imageData = myProfile.avatar {
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
                    Text(myProfile.name)
                        .foregroundStyle(.textBlue)
                        .font(.title)
                        .fontDesign(.rounded)
                        .bold()
                    
                    Text(myProfile.birthdate, format: Date.FormatStyle(date: .abbreviated))
                        .font(.title2)
                        .foregroundStyle(.textBlue)
                        .fontDesign(.rounded)
                        .fontWeight(.semibold)
                        .padding(.top, 2)
                }
                .padding(.bottom, 5)
                
                VStack {
                    Group {
                        HStack(alignment: .center) {
                            Text("Wish List")
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
                            
                            if let gifts = myProfile.gifts, !gifts.isEmpty {
                                let image = Image(.invite)
                                let link = URL(string: "https://apps.apple.com/us/app/giftview/id6474200424")!
                                
                                let giftString = createList()
                                
                                ShareLink(item: giftString,
                                          preview: SharePreview(
                                            Text("Share your wishlist!"),
                                            image: image)) {
                                                Image(systemName: "square.and.arrow.up")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 25, height: 25)
                                                    .foregroundStyle(.buttonBlue)
                                                    .padding(.horizontal)
                                                
                                            }
                            }
                        }
                    }
                    
                    if let gifts = myProfile.gifts {
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
                        
                        if gifts.isEmpty {
                            ContentUnavailableView {
                                Label("Add gifts to get started", systemImage: "plus.circle")
                            }
                        } else {
                            if viewModel.isShowingImageList == "images" {
                                WishGiftsGridView(gifts: gifts) { gift in
                                    viewModel.selectedGift = gift
                                }
                            } else if viewModel.isShowingImageList == "list" {
                                WishGiftsChecklistView(gifts: gifts)
                                Spacer()
                            }
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $viewModel.isAddGiftShowing) {
            AddWishGiftView(myProfile: myProfile)
        }
        .sheet(item: $viewModel.selectedGift) { giftToDisplay in
            WishGiftDetailsView(gift: giftToDisplay)
        }
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                NavigationLink {
                    SettingsView()
                } label: {
                    Image(systemName: "gear")
                        .foregroundStyle(.buttonBlue)
                }
                
            }
        }
    }
    
    private func createList() -> String {
        guard let gifts = myProfile.gifts else { return "N/A"}
        var giftList = "\(myProfile.name) shared their wishlist with you!\n\n"
        for gift in gifts {
            guard let link = gift.link else { return "" }
            giftList.append("\(gift.title) (\(link))\n")
        }
        giftList.append("\nDownload GiftView to make your own!\nhttps://apps.apple.com/us/app/giftview/id6474200424")
        return giftList
    }
}
