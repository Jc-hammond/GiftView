//
//  ProfileCardView.swift
//  GiftView
//
//  Created by Connor Hammond on 8/14/23.
//

import SwiftUI
import SwiftData

struct ProfileCardView: View {
    @Environment(\.modelContext) private var modelContext
    @State var profile: Profile
    var width: CGFloat
    var height: CGFloat
    
    @Binding var isEditable: Bool
    
    var onDelete: (Profile) -> Void
    
    let colors = [Color.black.opacity(0.75), Color.clear]
    
    var body: some View {
        ZStack {
            Group {
                if let imageData = profile.avatar {
                    let uiImage = UIImage(data: imageData)
                    Image(uiImage: uiImage!)
                        .resizable()
                        .scaledToFill()
                        .frame(width: width, height: height)
                        .cornerRadius(15)
                        .overlay {
                            LinearGradient(colors: colors, startPoint: .bottom, endPoint: .top)
                                .frame(width: width, height: height)
                                .cornerRadius(15)
                        }
                } else {
                    Image(systemName: "person.circle")
                        .resizable()
                        .frame(width: 85, height: 85)
                        .cornerRadius(15)
                        .scaledToFit()
                        .tint(.white)
                        .overlay {
                            LinearGradient(colors: colors, startPoint: .bottom, endPoint: .top)
                                .frame(width: 115, height: 115)
                                .cornerRadius(15)
                        }
                }
                HStack {
                    
                    VStack(alignment: .leading) {
                        Spacer()
                        Text(profile.formattedName)
                            .font(.system(size: 16))
                            .fontDesign(.rounded)
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                            .multilineTextAlignment(.leading)
                        Text(profile.birthdate, format: Date.FormatStyle(date: .abbreviated))
                            .font(.caption)
                            .fontDesign(.rounded)
                            .foregroundStyle(.white)
                        
                    }
                    .padding(.bottom, 8)
                    Spacer()
                }
                .padding(.horizontal, 8)
            }
            
            if isEditable {
                VStack {
                    HStack {
                        HStack {
                            Spacer()
                            Button(action: {
                                onDelete(profile)
                            }, label: {
                                Image(systemName: "minus")
                                    .frame(width: 30, height: 30)
                                    .background(Color.errorRed)
                                    .clipShape(Circle())
                                    .foregroundColor(.white)
                            })
                            .padding(.top, 8)
                            
                        }
                        Spacer()
                    }
                    Spacer()
                    
                }
            }
        }
    }
    
}
