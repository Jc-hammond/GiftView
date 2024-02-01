//
//  AddProfileModalViewModel.swift
//  GiftView
//
//  Created by Connor Hammond on 11/18/23.
//

import Foundation
import PhotosUI
import SwiftUI

class AddProfileModalViewModel: ObservableObject {
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var name: String = ""
    @Published var birthdate: Date = .now
    @Published var selectedAvatar: PhotosPickerItem?
    @Published var avatarData: Data?
    @Published var birthdateString = ""
    
    @Published var birthdateChanged = false
    @Published var displayError = false
    @Published var errorMessage = ""
    @Published var datePickerId = 0

    @Published var saveButtonTitle = "Add Profile"
    @Published var saveButttonImage = "plus.circle"
    
    var fullName: String {
        if (lastName.isEmpty) {
            return firstName
        } else {
            return firstName + " " + lastName
        }
    }
    
    var formIsBlank: Bool {
        return name.isEmpty || avatarData == nil
    }
    
    func updateBirthdate(newDate: Date) {
        self.birthdate = newDate
        self.birthdateChanged = true
        self.handleErrors()
    }
    
    func convertPhotoToData() async {
        if let data = try? await selectedAvatar?.loadTransferable(type: Data.self) {
            DispatchQueue.main.async {
                self.avatarData = data
            }
        }
    }
    
    func resetForm() {
            name = ""
            birthdate = .now
            birthdateString = ""
            selectedAvatar = nil
            avatarData = nil
            handleErrors()
    }
    
    func handleErrors() {
        if avatarData == nil && !name.isEmpty {
            DispatchQueue.main.async {
                self.errorMessage = "Please add a picture to continue"
                self.displayError = true
            }
        }
        
        if avatarData == nil && name.isEmpty {
            DispatchQueue.main.async {
                self.errorMessage = "Please fill out the form to continue"
                self.displayError = true
            }
        }
                
        if !formIsBlank {
            DispatchQueue.main.async {
                self.errorMessage = ""
                self.displayError = false
            }
        }
    }
    
    func save(profile: Profile, onCommit: () -> Void) async {
        let _ = await NotificationsManager.shared.checkForNotificationPermissions(update: profile)
        profile.avatar = avatarData
        onCommit()
        saveButtonTitle = "Saved"
        saveButttonImage = "checkmark.circle.fill"
        NotificationsManager.shared.scheduleBirthdayNotification(for: profile)
    }
}
