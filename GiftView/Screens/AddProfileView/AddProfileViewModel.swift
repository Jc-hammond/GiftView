//
//  AddProfileViewModel.swift
//  GiftView
//
//  Created by Connor Hammond on 12/7/23.
//

import Foundation
import PhotosUI
import SwiftUI
import SwiftData
import UserNotifications

class AddProfileViewModel: ObservableObject {
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
//        let firstNameBlanke = firstName.isEmpty
//        let lastNameBlank = lastName.isEmpty
        let nameIsBlank = name.isEmpty
        let dataBlank = avatarData == nil
        let isBlank = nameIsBlank || dataBlank || !birthdateChanged
        return isBlank
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
//        firstName = ""
//        lastName = ""
        name = ""
        birthdate = .now
        birthdateString = ""
        selectedAvatar = nil
        avatarData = nil
        
        handleErrors()
    }
    
    func addNewProfile(name: String, birthdate: Date, avatar: Data?, modelContext: ModelContext) {
        let newProfile = Profile(name: name, birthdate: birthdate)
        
        if let newAvatar = avatar {
            newProfile.avatar = newAvatar
        }
        
        handleErrors()
        
        NotificationsManager.shared.checkForNotificationPermissions(update: newProfile)
        
        modelContext.insert(newProfile)
        
        NotificationsManager.shared.scheduleBirthdayNotification(for: newProfile)
        
        newProfile.hasNotifications = true
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
        
        if avatarData != nil && name.isEmpty  {
            DispatchQueue.main.async {
                self.errorMessage = "Please add a name to continue"
                self.displayError = true
            }
        }
        
        if avatarData != nil && !name.isEmpty && !birthdateChanged {
            DispatchQueue.main.async {
                self.errorMessage = "Please add a birthdate to continue"
                self.displayError = true
            }
        }
        
//        if avatarData != nil && firstName.isEmpty && !lastName.isEmpty {
//            DispatchQueue.main.async {
//                self.errorMessage = "Please add a first name to continue"
//                self.displayError = true
//            }
//        }
//        
//        if avatarData != nil && !firstName.isEmpty && lastName.isEmpty {
//            DispatchQueue.main.async {
//                self.errorMessage = "Please add a last name to continue"
//                self.displayError = true
//            }
//        }
        
        if !formIsBlank {
            DispatchQueue.main.async {
                self.errorMessage = ""
                self.displayError = false
            }
        }
    }
}
