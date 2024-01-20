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
    
    func toggleNotifications(for profile: Profile) {
        //check notif permissions
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            
            //if allowed -> toggle notifications on or off
            if settings.authorizationStatus == .authorized {
                DispatchQueue.main.async {
                    profile.hasNotifications.toggle()
                }
                
                if profile.hasNotifications == true {
                    //notifications have been toggled ON
                    self.scheduleBirthdayNotification(for: profile)
                } else {
                    //notifications have been toggled OFF
                    self.removeScheduledNotifications(for: profile)
                }
                
            }
            //if not allowed -> pop up informing user that notifications need to be enabled for birthday reminders -> go to settings -> don't toggle notifications
            
            if settings.authorizationStatus == .denied || settings.authorizationStatus == .notDetermined {
                DispatchQueue.main.async {
                    self.isNotificationsAlertShowing = true
                }
            }
        }
    }
    
    func scheduleBirthdayNotification(for profile: Profile) {
        
        let calendar = Calendar.current
        guard let notificationDate = calendar.date(byAdding: .month, value: -1, to: profile.birthdate) else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "Upcoming Birthday"
        content.body = "\(profile.name)'s birthday is in a month! Take a look at your ideas."
        content.sound = .default
        
        let dateComponents = calendar.dateComponents([.day, .month, .year], from: notificationDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(identifier: profile.id.uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            }
        }
        
    }
    
    func removeScheduledNotifications(for profile: Profile) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [profile.id.uuidString])
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
