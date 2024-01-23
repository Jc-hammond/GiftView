//
//  GiftViewApp.swift
//  GiftView
//
//  Created by Connor Hammond.
//

import SwiftUI
import SwiftData
import WishKit

@main
struct GiftViewApp: App {
    @AppStorage("isOnboarding") var isOnboarding: Bool = true
    @StateObject var reviewsManager = RequestReviewManager()
    
    init() {
            WishKit.configure(with: "FDF452CB-3522-486D-A05A-303C948FC480")
            WishKit.config.buttons.segmentedControl.display = .hide
            WishKit.config.commentSection = .hide
            WishKit.theme.primaryColor = .buttonBlue
        }
    
    var body: some Scene {
        WindowGroup {
            if isOnboarding {
                OnboardingView()
            } else {
                ProfilesView()
            }
        }
        .modelContainer(for: [Profile.self, Gift.self, MyProfile.self])
        .environmentObject(reviewsManager)
    }
}
