//
//  AddGiftView.swift
//  GiftView
//
//  Created by Connor Hammond on 8/15/23.
//

import SwiftUI
import PhotosUI
import SwiftData

struct AddGiftView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State var profile: Profile?
    @State private var giftPhoto: PhotosPickerItem?
    @State private var giftPhotoData: Data?
    
    @State private var giftName: String = ""
    @State private var giftLink: String = ""
    @State private var errorMessage: String = ""
    @FocusState private var nameIsFocused: Bool
    @FocusState private var linkIsFocused: Bool
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.background).ignoresSafeArea()
                Form {
                    TextField("Gift Idea", text: $giftName)
                        .focused($nameIsFocused)
                        .autocorrectionDisabled()
                        .onSubmit {
                            nameIsFocused = false
                        }
                    
                    TextField("Link", text: $giftLink)
                        .focused($linkIsFocused)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .onSubmit {
                            linkIsFocused = false
                        }
                    
                    PhotosPicker(selection: $giftPhoto, matching: .images) {
                        Label("Add photo", systemImage: "camera")
                    }
                    
                    if let photoData = giftPhotoData  {
                        let uiImage = UIImage(data: photoData)
                        Image(uiImage: uiImage!)
                            .resizable()
                            .scaledToFit()
                            .onTapGesture {
                                nameIsFocused = false
                                linkIsFocused = false
                            }
                    }
                }
                .navigationTitle("Add a gift")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            nameIsFocused = false
                            linkIsFocused = false
                            if isValidURL(giftLink) {
                                addGift()
                                dismiss()
                            } else {
                                errorMessage = "Please enter a valid link."
                            }
                        } label: {
                            Text("Save")
                        }
                    }
                    
                    if errorMessage != "" {
                        ToolbarItem(placement: .principal) {
                            GVErrorMessage(message: errorMessage)
                                .onTapGesture {
                                    nameIsFocused = false
                                    linkIsFocused = false
                                }
                        }
                    }
                    
                }
            }
        }
        .presentationDetents([.large])
        .task(id: giftPhoto) {
            if let data = try? await giftPhoto?.loadTransferable(type: Data.self) {
                giftPhotoData = data
            }
            nameIsFocused = false
            linkIsFocused = false
        }
        
    }
    
    func addGift() {
        let newGift = Gift(title: giftName,image: giftPhotoData, link: giftLink, profile: profile)
        
        modelContext.insert(newGift)
        profile?.gifts?.append(newGift)
    }
    
    func isValidURL (_ urlString: String?) -> Bool {
        let urlRegEx = "(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+"
        return NSPredicate(format: "SELF MATCHES %@", urlRegEx).evaluate(with: urlString)
    }
}
