//
//  NotificationsManager.swift
//  GiftView
//
//  Created by Connor Hammond on 1/7/24.
//

import SwiftUI
import UserNotifications

class NotificationsManager {
    static let shared = NotificationsManager()
    
    @AppStorage("isOnboarding") var isOnboarding: Bool?
    
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("all set")
                DispatchQueue.main.async {
                    self.isOnboarding = false
                }
            } else if let error = error {
                print(error.localizedDescription)
            }
            //This navigates away from onboarding reguardless of what the user decides on permissions
            DispatchQueue.main.async {
                self.isOnboarding = false
            }
        }
        //TODO: Handle displaying info on what to do if declined
    }
    
    func checkForNotificationPermissions(update profile: Profile) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                profile.hasNotifications = true
            } else {
                return
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
    
    //TODO: Tests work ✅
    func testNotification(with name: String) {
        
        let calendar = Calendar.current
        // Schedule the notification for 5 seconds in the future
        guard let notificationDate = calendar.date(byAdding: .second, value: 5, to: Date()) else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "Upcoming Birthday"
        content.body = "\(name)'s birthday is in a month! Take a look at your ideas."
        content.sound = .default
        
        let dateComponents = calendar.dateComponents([.day, .month, .year, .hour, .minute, .second], from: notificationDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            }
        }
    }
    
    //TODO: Handle turn off notifications
    func disableAllNotifications() {
        
    }
    
    //TODO: Handle turn on notifications
    func enableAllNotifications() {
        
    }

}
