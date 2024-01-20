//
//  GVPhotoPicker.swift
//  GiftView
//
//  Created by Connor Hammond on 1/7/24.
//

import SwiftUI
import PhotosUI

struct GVPhotoPicker: View {
    @Binding var photoSelection: PhotosPickerItem?
    var avatarData: Data?
    var photoOnAppear: () -> Void
    var placeholderOnChange: () -> Void
    
    var body: some View {
        HStack {
            Spacer()
            PhotosPicker(selection: $photoSelection, matching: .images) {
                if let photoData = avatarData  {
                    let uiImage = UIImage(data: photoData)
                    Image(uiImage: uiImage!)
                        .resizable()
                        .scaledToFill()
                        .clipShape(Circle())
                        .frame(width: 150, height: 150)
                        .clipped()
                        .padding()
                        .onAppear(perform: {
                            photoOnAppear()
                        })
                } else {
                    Image(systemName: "person.crop.circle.badge.plus")
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(.buttonBlue)
                        .frame(width: 150, height: 150)
                        .clipShape(Circle())
                        .padding()
                        .offset(x: -5)
                        .onChange(of: photoSelection) {
                            placeholderOnChange()
                        }
                }
            }
            Spacer()
        }
    }
}
