//
//  SettingsViewModel.swift
//  GiftView
//
//  Created by Connor Hammond on 1/22/24.
//

import Foundation
import SwiftUI

class SettingsViewModel: ObservableObject {
    @AppStorage("notificationsOn") var notificationsOn = false
    @AppStorage("daysBeforeReminder") var daysBeforeReminder = 30
    @Published var showAlert = false
    var profiles: [Profile] = []
    
    var daysBeforeReminderString: String {
        get { String(daysBeforeReminder) }
        set {
            if let value = Int(newValue), value > 0 {
                daysBeforeReminder = value
            }
        }
    }
    
    func toggleNotifications() {
        switch notificationsOn {
        case true: NotificationsManager.shared.enableAllNotifications()
        case false: NotificationsManager.shared.disableAllNotifications()
        }
    }
    
    func onSubmitNewDays() {
        if daysBeforeReminder == 0 {
            daysBeforeReminder = 30
        }
        
        NotificationsManager.shared.updateScheduledNotificationsDaysBefore(newDaysBefore: daysBeforeReminder)
        
        DispatchQueue.main.async {
            self.showAlert = true
        }
    }
}

struct DismissingKeyboard: ViewModifier {
    func body(content: Content) -> some View {
        content
            .onTapGesture {
                let keyWindow = UIApplication.shared.connectedScenes
                    .filter({$0.activationState == .foregroundActive})
                    .map({$0 as? UIWindowScene})
                    .compactMap({$0})
                    .first?.windows
                    .filter({$0.isKeyWindow}).first
                keyWindow?.endEditing(true)
            }
    }
}
