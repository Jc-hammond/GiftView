//
//  SettingsViewModel.swift
//  GiftView
//
//  Created by Connor Hammond on 1/22/24.
//

import Foundation
import SwiftUI

class SettingsViewModel: ObservableObject {
    @Published var notificationsOn = false
    @Published var daysBefore = "30"
    
    var daysBeforeText: String {
        if daysBefore.isEmpty {
            return "0"
        } else {
            return daysBefore
        }
    }
    
    func toggleNotifications() {
        if notificationsOn {
            NotificationsManager.shared.disableAllNotifications()
        } else {
            NotificationsManager.shared.enableAllNotifications()
        }
    }
    
    func onSubmitNewDays() {
        if daysBefore.isEmpty {
            daysBefore = "30"
        } else { return }
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
