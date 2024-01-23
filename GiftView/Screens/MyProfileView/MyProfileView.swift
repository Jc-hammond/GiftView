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
                }
            }
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
}
