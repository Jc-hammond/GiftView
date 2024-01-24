//
//  AddWishgiftView.swift
//  GiftView
//
//  Created by Connor Hammond on 1/23/24.
//

import SwiftUI
import PhotosUI
import SwiftData

struct AddWishGiftView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State var myProfile: MyProfile?
    @State private var giftPhoto: PhotosPickerItem?
    @State private var giftPhotoData: Data?
    
    @State private var giftName: String = ""
    @State private var giftLink: String = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.background).ignoresSafeArea()
                Form {
                    
                    TextField("Gift Idea", text: $giftName)
                    
                    TextField("Link", text: $giftLink)
                    
                    PhotosPicker(selection: $giftPhoto, matching: .images) {
                        Label("Add photo", systemImage: "camera")
                    }
                    
                    if let photoData = giftPhotoData  {
                        let uiImage = UIImage(data: photoData)
                        Image(uiImage: uiImage!)
                            .resizable()
                            .scaledToFit()
                    }
                    
                }
                .navigationTitle("Add a gift")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            addGift()
                            dismiss()
                        } label: {
                            Text("Save")
                        }
                    }
                }
            }
        }
        .presentationDetents([.medium])
        .task(id: giftPhoto) {
            if let data = try? await giftPhoto?.loadTransferable(type: Data.self) {
                giftPhotoData = data
            }
        }
       
    }
    
    func addGift() {
        let newGift = WishGift(title: giftName,image: giftPhotoData, link: giftLink, myProfile: myProfile)
        
        modelContext.insert(newGift)
        myProfile?.gifts?.append(newGift)
    }
}

#Preview {
    AddWishGiftView()
}
