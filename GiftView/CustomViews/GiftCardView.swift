//
//  GiftCardView.swift
//  GiftView
//
//  Created by Connor Hammond on 8/15/23.
//

import SwiftUI

struct GiftCardView: View {
    @Environment(\.modelContext) private var modelContext
    @State var gift: Gift
    
    let colors = [Color.black.opacity(0.75), Color.clear]
    
    var body: some View {
        ZStack {
            
            if let imageData = gift.image {
                let uiImage = UIImage(data: imageData)
                Image(uiImage: uiImage!)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 110, height: 110)
                    .cornerRadius(15)
                    .overlay {
                        LinearGradient(colors: colors, startPoint: .bottom, endPoint: .top)
                            .frame(width: 110, height: 110)
                            .cornerRadius(15)
                    }
            }
            HStack {
                
                VStack(alignment: .leading) {
                    HStack {
                        Spacer()
                        Image(systemName: gift.isPurchased ? "checkmark.circle.fill" : "checkmark.circle")
                            .tint(Color.white)
                            .padding(.horizontal, 3)
                            .padding(.vertical, 8)
                    }
                    
                    Spacer()
                        Text(gift.title)
                            .font(.system(size: 16))
                            .fontWeight(.semibold)
                            .fontDesign(.rounded)
                            .foregroundStyle(.white)
                }
                .padding(.leading, 10)
                .padding(.bottom, 8)
                Spacer()
            }
            
        }
    }
}
