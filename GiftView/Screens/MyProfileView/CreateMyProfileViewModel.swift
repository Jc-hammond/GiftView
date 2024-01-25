//
//  CreateMyProfileViewModel.swift
//  GiftView
//
//  Created by Connor Hammond on 1/22/24.
//

import Foundation
import PhotosUI
import SwiftUI
import SwiftData

class CreateMyProfileViewModel: ObservableObject {
    @AppStorage("firstProfileVisit") var firstVisit: Bool = true
    
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
    
    var formIsBlank: Bool {
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
        name = ""
        birthdate = .now
        birthdateString = ""
        selectedAvatar = nil
        avatarData = nil
        
        handleErrors()
    }
    
    //MARK: ----- CRUD -----
    func addNewProfile(name: String, birthdate: Date, avatar: Data?, modelContext: ModelContext) {
        let newProfile = MyProfile(name: name, birthdate: birthdate)
        
        if let newAvatar = avatar {
            newProfile.avatar = newAvatar
        }
        
        handleErrors()
                
        modelContext.insert(newProfile)
        
        completeFirstVisit()
    }
    
    func completeFirstVisit() {
        firstVisit = false
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
        
        if !formIsBlank {
            DispatchQueue.main.async {
                self.errorMessage = ""
                self.displayError = false
            }
        }
    }
}
