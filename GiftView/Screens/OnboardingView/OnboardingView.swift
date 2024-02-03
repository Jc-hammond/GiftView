//
//  OnboardingView.swift
//  GiftView
//
//  Created by Connor Hammond on 12/12/23.
//

import SwiftUI

struct OnboardingView: View {
    @AppStorage("isOnboarding") var isOnboarding: Bool?
    @StateObject var viewModel = OnboardingViewModel()
    #if os(iOS)
    @State private var screenHeight = UIScreen.main.bounds.height
    #endif
    
    #if os(visionOS)
    @State private var screenHeight = CGFloat(100)
    #endif
    
    var body: some View {
        ZStack {
            Color(.background).ignoresSafeArea()
            VStack {
                Image(uiImage: (UIImage(named: "AppIcon") ?? UIImage(systemName: "person.circle"))!)
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 25))
                    .frame(width: 200)
                    .padding(.top, screenHeight / 20)
                    
                
                Text("Welcome to GiftView")
                    .font(.largeTitle).bold()
                    .fontDesign(.rounded)
                    .foregroundStyle(.textBlue)
                    .padding(.top, 15)
                    .padding(.bottom, 15)
                
                VStack(alignment: .leading) {
                    Group {
                        Text("Personalized Profiles:")
                            .font(.title2).bold()
                            .fontDesign(.rounded)
                            .foregroundStyle(.textBlue)
                            .multilineTextAlignment(.leading)
                        Text("Create custom profiles for your friends and family.")
                            .font(.title3)
                            .fontDesign(.rounded)
                            .foregroundStyle(.textBlue)
                            .padding(.bottom, 4)
                            .multilineTextAlignment(.leading)
                    }
                    
                    
                    Group {
                        Text("Gift Tracking:")
                            .font(.title2).bold()
                            .fontDesign(.rounded)
                            .foregroundStyle(.textBlue)
                            .multilineTextAlignment(.leading)
                        Text("Keep a running list of gift ideas for each person.")
                            .font(.title3)
                            .fontDesign(.rounded)
                            .foregroundStyle(.textBlue)
                            .padding(.bottom, 4)
                            .multilineTextAlignment(.leading)
                    }
                    
                    
                    Group {
                        Text("Birthday Reminders:")
                            .font(.title2).bold()
                            .fontDesign(.rounded)
                            .foregroundStyle(.textBlue)
                            .multilineTextAlignment(.leading)
                        Text("Never miss an important date!")
                            .font(.title3)
                            .fontDesign(.rounded)
                            .foregroundStyle(.textBlue)
                            .padding(.bottom, 4)
                            .multilineTextAlignment(.leading)
                    }
                    
                }
                .padding(.horizontal, 30)
                
                Button {
                    viewModel.requestNotificationPermission()
                } label: {
                    Text("Get Started")
                        .font(.title).bold()
                        .fontDesign(.rounded)
                        .foregroundStyle(.textBlue)
                        .padding(.horizontal, 70)
                }
                .buttonStyle(.borderedProminent)
                .tint(.buttonBlue)
                .padding(.top, 15)
                
                Spacer()
            }
        }
    }
}

#Preview {
    OnboardingView()
}
