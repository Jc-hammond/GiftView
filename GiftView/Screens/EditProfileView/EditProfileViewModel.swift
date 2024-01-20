//
//  EditProfileViewModel.swift
//  GiftView
//
//  Created by Connor Hammond on 12/7/23.
//

import Foundation
import SwiftUI
import PhotosUI

class EditProfileViewModel: ObservableObject {
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var name: String = ""
    @Published var birthdate: Date = .now
    @Published var selectedAvatar: PhotosPickerItem?
    @Published var avatarData: Data?
    @Published var birthdateString = ""
    
    @Published var displayError = false
    @Published var errorMessage = ""
    @Published var datePickerId = 0
    @Published var nameWasUpdated = false
    @Published var birthdateWasUpdated = false
    @Published var photoWasUpdated = false
    
    @Published var saveButtonTitle = "Save Changes"
    @Published var saveButttonImage = "checkmark.circle"
    
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
        let isBlank = nameIsBlank || dataBlank
        return isBlank
    }
    
    var formIsUpdated: Bool {
        return photoWasUpdated || nameWasUpdated || birthdateWasUpdated
    }
    
    func convertPhotoToData(for profile: Profile) async {
        if let data = try? await selectedAvatar?.loadTransferable(type: Data.self) {
            DispatchQueue.main.async {
                self.avatarData = data
                profile.avatar = self.avatarData
                self.photoWasUpdated = true
            }
        }
    }
    
    func resetForm() {
        name = ""
        birthdate = .now
        birthdateString = ""
        selectedAvatar = nil
        avatarData = nil
    }
    
    func handleErrors() {
        if avatarData == nil && !firstName.isEmpty && !lastName.isEmpty {
            DispatchQueue.main.async {
                self.errorMessage = "Please add a picture to continue"
                self.displayError = true
            }
        }
        
        if avatarData == nil && firstName.isEmpty && lastName.isEmpty {
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
        
        if !formIsBlank {
            DispatchQueue.main.async {
                self.errorMessage = ""
                self.displayError = false
            }
        }
    }
    
    func checkForNameChange(name: String) {
        let newValue = name
        let initialValue = self.name
        if initialValue != newValue {
            nameWasUpdated = true
        }
    }
    
    func checkForBirthdateUpdate(birthdate: Date) {
        let newValue = birthdate
        let initialValue = self.birthdate
        if initialValue != newValue {
            birthdateWasUpdated = true
        }
    }
    
    func checkForPhotoUpdate(photo: Data) {
        let newValue = self.avatarData
        let initialValue = photo
        if initialValue != newValue {
            photoWasUpdated = true
        }
    }
    
    func saveButtonPressed(profile: Profile) {
        if photoWasUpdated {
            DispatchQueue.main.async {
                profile.avatar = self.avatarData
            }
        }
        
        saveButtonTitle = "Saved"
        saveButttonImage = "checkmark.circle.fill"
    }
}
