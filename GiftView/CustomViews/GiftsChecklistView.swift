//
//  GiftsView.swift
//  GiftView
//
//  Created by Connor Hammond on 1/22/24.
//

import SwiftUI

struct GiftsChecklistView: View {
    var gifts: [Gift]
    
    var body: some View {
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
                                .foregroundStyle(Color.textBlue)
                        }
                    }
                    .listRowBackground(Color.textFieldBackground)
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
                                .foregroundStyle(Color.textBlue)
                        }
                    }
                    .listRowBackground(Color.textFieldBackground)
                }
            }
        }
        .listStyle(.plain)
    }
}

struct WishGiftsChecklistView: View {
    var gifts: [WishGift]
    
    var body: some View {
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
                                .foregroundStyle(Color.textBlue)
                        }
                    }
                    .listRowBackground(Color.textFieldBackground)
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
                                .foregroundStyle(Color.textBlue)
                        }
                    }
                    .listRowBackground(Color.textFieldBackground)
                }
            }
        }
        .listStyle(.plain)
    }
}
