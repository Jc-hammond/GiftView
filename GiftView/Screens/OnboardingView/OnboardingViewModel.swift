//
//  OnboardingViewModel.swift
//  GiftView
//
//  Created by Connor Hammond on 12/12/23.
//

import Foundation
import SwiftUI
import UserNotifications

class OnboardingViewModel: ObservableObject {
    @AppStorage("isOnboarding") var isOnboarding: Bool?
    
    func requestNotificationPermission() {
        NotificationsManager.shared.requestNotificationPermission()
    }
}
