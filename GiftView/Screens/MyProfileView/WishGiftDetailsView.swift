//
//  WishGiftDetails.swift
//  GiftView
//
//  Created by Connor Hammond on 1/23/24.
//

import SwiftUI

struct WishGiftDetailsView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    
    @State var gift: WishGift
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.background).ignoresSafeArea()
                
                VStack {
                    if let photoData = gift.image  {
                        let uiImage = UIImage(data: photoData)
                        Image(uiImage: uiImage!)
                            .resizable()
                            .scaledToFit()
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .padding(.horizontal, 25)
                    } else {
                        Circle().fill(.errorRed)
                            .frame(width: 50)
                    }
                    
                    HStack {
                        Spacer()
                        if let giftLink = gift.link {
                            let url = URL(string: giftLink)
                            Link(destination: (url ?? URL(string: "https://www.connorhammondapps.com")!)) {
                                HStack {
                                    Text("Go to site")
                                        .fontDesign(.rounded)
                                        
                                    Image(systemName: "link.circle")
                                }
                            }
                                .buttonStyle(.borderedProminent)
                                .buttonBorderShape(.capsule)
                                .tint(.buttonBlue)
                            
                           
                            
                        }
                        
                        Spacer()
                        
                        Button {
                            gift.isPurchased.toggle()
                        } label: {
                            HStack {
                                Text("Purchased:")
                                
                                Image(systemName: gift.isPurchased ? "checkmark.circle.fill" : "checkmark.circle")
                                
                            }
                            
                        }
                        .buttonBorderShape(.capsule)
                        .buttonStyle(.bordered)
                        .tint(.buttonBlue)
                        
                        Spacer()
                    }
                    .padding()
                    
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text(gift.title)
                        .font(.title)
                        .foregroundStyle(.textBlue)
                        .fontDesign(.rounded)
                        .bold()
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label:  {
                        Text("Done")
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                        modelContext.delete(gift)
                    } label: {
                        Image(systemName: "trash")
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .presentationDetents([.medium])
        
    }
}
