//
//  ProfileDetailViewModel.swift
//  GiftView
//
//  Created by Connor Hammond on 12/5/23.
//

import UIKit
import UserNotifications

class ProfileDetailViewModel: ObservableObject {
    @Published var selectedGift: Gift? = nil
    @Published var isAddGiftShowing: Bool = false
    @Published var isShowingImageList: String = "images"
    @Published var isNotificationsAlertShowing = false
    
    func daysUntilNextBirthday(from birthdate: Date) -> Int? {
        let currentDate = Date()
        
        // This year's birthday
        guard let thisYearBirthday = Calendar.current.date(from: DateComponents(year: currentDate.year, month: birthdate.month, day: birthdate.day)) else {
            return nil
        }
        
        // Next year's birthday
        guard let nextYearBirthday = thisYearBirthday.addingYears(1) else {
            return nil
        }
        
        if currentDate < thisYearBirthday {
            // If the birthday hasn't occurred yet this year
            return Calendar.current.dateComponents([.day], from: currentDate, to: thisYearBirthday).day
        } else {
            // If the birthday already occurred this year
            return Calendar.current.dateComponents([.day], from: currentDate, to: nextYearBirthday).day
        }
    }
    
    func toggleNotifications(for profile: Profile) async {
        // Check for notification permissions asynchronously
        let authStatus = await NotificationsManager.shared.checkForNotificationPermissions(update: profile)
        
        // Handle the case where permission is denied or not determined
        if authStatus == .denied || authStatus == .notDetermined {
            // Since this is UI-related, it needs to be run on the main thread
            DispatchQueue.main.async {
                self.isNotificationsAlertShowing = true
                profile.hasNotifications = false
            }
            return
        }

        // Handle the case where notifications are enabled/disabled based on the profile's setting
        DispatchQueue.main.async {
            switch profile.hasNotifications {
            case true:
                profile.hasNotifications = false
                NotificationsManager.shared.removeScheduledNotifications(for: profile)
            
            case false: 
                profile.hasNotifications = true
                NotificationsManager.shared.scheduleBirthdayNotification(for: profile)
            }
        }
    }

    
    func goToSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else {
            print("Invalid URL")
            return
        }
        
        DispatchQueue.main.async {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                print("Can't open URL")
            }
        }
    }

    
}
