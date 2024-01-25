//
//  GiftsGridView.swift
//  GiftView
//
//  Created by Connor Hammond on 1/22/24.
//

import SwiftUI

struct GiftsGridView: View {
    
    var gifts: [Gift]
    let gridItems = [GridItem(), GridItem(), GridItem()]
    var onGiftPress: (Gift) -> Void
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: gridItems, spacing: 8) {
                ForEach(gifts.sorted(by: { $0.title < $1.title }), id: \.self) { gift in
                    Button {
                        onGiftPress(gift)
                    } label: {
                        GiftCardView(gift: gift)
                    }
                }
            }
            .padding(.horizontal, 10)
        }
    }
}

struct WishGiftsGridView: View {
    
    var gifts: [WishGift]
    let gridItems = [GridItem(), GridItem(), GridItem()]
    var onGiftPress: (WishGift) -> Void
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: gridItems, spacing: 8) {
                ForEach(gifts.sorted(by: { $0.title < $1.title }), id: \.self) { gift in
                    Button {
                        onGiftPress(gift)
                    } label: {
                        WishGiftCardView(gift: gift)
                    }
                }
            }
            .padding(.horizontal, 10)
        }
    }
}
