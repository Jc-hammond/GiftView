//
//  EditProfilePhotoPicker.swift
//  GiftView
//
//  Created by Connor Hammond on 2/1/24.
//

import SwiftUI
import PhotosUI

struct EditProfilePhotoPicker: View {
    @Binding var selectedAvatar: PhotosPickerItem?
    var profile: Profile
    var avatarData: Data?
    
    var body: some View {
        PhotosPicker(selection: $selectedAvatar, matching: .images) {
            if let photoData = profile.avatar  {
                let uiImage = UIImage(data: photoData)
                Image(uiImage: uiImage!)
                    .resizable()
                    .scaledToFill()
                    .clipShape(Circle())
                    .frame(width: 135, height: 135)
                    .clipped()
                    .padding()
                    
            } else if let photoData = avatarData {
                let uiImage = UIImage(data: photoData)
                Image(uiImage: uiImage!)
                    .resizable()
                    .scaledToFill()
                    .clipShape(Circle())
                    .frame(width: 135, height: 135)
                    .clipped()
                    .padding()
                    
            } else {
                Image(systemName: "person.crop.circle.badge.plus")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(.buttonBlue)
                    .frame(width: 135, height: 135)
                    .clipShape(Circle())
                    .padding()
                    .offset(x: -5)
            }
        }
    }
}
