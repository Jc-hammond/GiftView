//
//  MyProfileToolbarView.swift
//  GiftView
//
//  Created by Connor Hammond on 2/1/24.
//

import SwiftUI

struct MyProfileToolbarView: View {
    var myProfile: MyProfile
    var body: some View {
        NavigationLink {
            MyProfileView(myProfile: myProfile)
        } label: {
            if let avatar = myProfile.avatar {
                let uiImage = UIImage(data: avatar)
                Image(uiImage: uiImage!)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
            } else {
                Image(systemName: "person.circle.fill")
            }
        }
    }
}
