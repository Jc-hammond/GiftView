//
//  NotificationsManager.swift
//  GiftView
//
//  Created by Connor Hammond on 1/7/24.
//

import SwiftUI
import UserNotifications
import SwiftData

class NotificationsManager {
    static let shared = NotificationsManager()
    
    @AppStorage("isOnboarding") var isOnboarding: Bool?
        
    //MARK: -- Notifiacation Permissions
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
    
    func checkForNotificationPermissions(update profile: Profile) async -> UNAuthorizationStatus {
        await withCheckedContinuation { continuation in
            UNUserNotificationCenter.current().getNotificationSettings { settings in
                continuation.resume(returning: settings.authorizationStatus)
            }
        }
    }

    //MARK: -- Notification Scheduling
    func scheduleBirthdayNotification(for profile: Profile) {
        let daysBefore = UserDefaults.standard.integer(forKey: "daysBeforeReminder")
        let calendar = Calendar.current
        //TODO: Allow custom days before in value
        guard let notificationDate = calendar.date(byAdding: .day, value: -daysBefore, to: profile.birthdate) else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "Upcoming Birthday"
        content.body = "\(profile.name)'s birthday is in \(daysBefore) days! Take a look at your ideas."
        content.sound = .default
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let birthdateString = dateFormatter.string(from: profile.birthdate)
        content.userInfo["birthdate"] = birthdateString
        
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
    
    func updateScheduledNotificationsDaysBefore(newDaysBefore: Int) {
        UNUserNotificationCenter.current().getPendingNotificationRequests { [weak self] requests in
            var updatedNotifications = [NotificationData]()

            for request in requests {
                guard let birthdateString = request.content.userInfo["birthdate"] as? String,
                      let birthdate = self?.parseDate(from: birthdateString) else {
                    continue
                }

                guard let newTriggerDate = Calendar.current.date(byAdding: .day, value: -newDaysBefore, to: birthdate) else {
                    continue
                }

                let dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: newTriggerDate)
                let newRequestData = NotificationData(id: request.identifier, 
                                                      title: request.content.title,
                                                      body: request.content.body,
                                                      birthday: request.content.userInfo["birthdate"] as! String,
                                                      dateComponents: dateComponents)
                
                updatedNotifications.append(newRequestData)
            }

            guard !updatedNotifications.isEmpty else {
                return
            }

            self?.storeNotifications(updatedNotifications)
            self?.rescheduleNotifications()
        }
    }

    
    //MARK: -- Notifications Enable/Diable
    func disableAllNotifications() {
        saveScheduledNotifications()
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    func enableAllNotifications() {
        guard let savedNotifications = getSavedNotifications() else { return }
        for notification in savedNotifications {
            scheduleNotification(from: notification)
        }
    }
    
    //MARK: -- Private Helper Methods
    // Helper function to parse a date string
    func parseDate(from dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd" // Adjust the format to match how the date is stored
        return dateFormatter.date(from: dateString)
    }
    
    private func storeNotifications(_ notifications: [NotificationData]) {
        //TODO: Check for duplicates before saving
        if let encoded = try? JSONEncoder().encode(notifications) {
            UserDefaults.standard.set(encoded, forKey: "savedNotifications")
        }
    }
    
    
    private func getSavedNotifications() -> [NotificationData]? {
        guard let savedData = UserDefaults.standard.data(forKey: "savedNotifications") else { return nil }
        return try? JSONDecoder().decode([NotificationData].self, from: savedData)
    }
    
    //MARK: --- Sub: Private -- Notification Scheduling
    
    private func scheduleNotification(from data: NotificationData) {
        let content = UNMutableNotificationContent()
        content.title = data.title
        content.body = data.body
        content.sound = .default
        content.userInfo["birthdate"] = data.birthday
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: data.dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: data.id, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error rescheduling notification: \(error.localizedDescription)")
            }
        }
    }
    
    private func saveScheduledNotifications() {
        UNUserNotificationCenter.current().getPendingNotificationRequests { [weak self] requests in
            let notifications = requests.map { request -> NotificationData in
                // Assuming all your notifications use UNCalendarNotificationTrigger
                let trigger = request.trigger as! UNCalendarNotificationTrigger
                return NotificationData(id: request.identifier,
                                        title: request.content.title,
                                        body: request.content.body,
                                        birthday: request.content.userInfo["birthdate"] as! String,
                                        dateComponents: trigger.dateComponents)
            }
            self?.storeNotifications(notifications)
        }
    }
    
    func rescheduleNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests() // Clear existing notifications
        let updatedNotifications = getSavedNotifications() ?? [] // Retrieve updated notifications
        for notification in updatedNotifications {
            scheduleNotification(from: notification) // Reschedule with new date
        }
    }
    
    
    //MARK: Testing ✅
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
}

//MARK: NotificationData Struct
struct NotificationData: Codable {
    var id: String
    var title: String
    var body: String
    var birthday: String
    var dateComponents: DateComponents
}
