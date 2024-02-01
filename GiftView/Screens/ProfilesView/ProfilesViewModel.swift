//
//  ProfilesViewModel.swift
//  GiftView
//
//  Created by Connor Hammond on 11/15/23.
//

import Foundation
import SwiftUI
import Contacts

@MainActor
class ProfilesViewModel: ObservableObject {
    @Published var profilesToSave = [Profile]()
    @Published var isProfilesListShowing: Bool = false
    @Published var isEditSheetShowing: Bool = false
    @Published var profileToEdit: Profile?
    
    @Published var isDeleteModalShowing = false
    @Published var profileToDelete: Profile?
        
    func createProfilesFrom(contacts: [CNContact]) -> [Profile] {
        let newProfiles = contacts.map { contact -> Profile in
            let name = CNContactFormatter.string(from: contact, style: .fullName) ?? "Unknown"
            let avatarData = contact.imageDataAvailable ? Data(contact.imageData!) : nil
            let birthdate = contact.birthday?.date ?? .now
            return Profile(name: name, birthdate: birthdate, avatar: avatarData)
        }
        return newProfiles
    }
    
    func onEditPress(profile: Profile) {
        DispatchQueue.main.async {
            self.profileToEdit = profile
            self.isEditSheetShowing = true
        }
    }
    
    func createProfilesAndShowAddView(contacts: [CNContact]) {
        profilesToSave = []
        let newProfiles = createProfilesFrom(contacts: contacts)
        
        DispatchQueue.main.async {
            newProfiles.forEach {profile in
                self.profilesToSave.append(profile)
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if !newProfiles.isEmpty {
                self.isProfilesListShowing = true
            }
        }
        
    }
    
    func dismissAddProfileModal(profile: Profile) {
        if profile.id.uuidString == profilesToSave.last?.id.uuidString {
            DispatchQueue.main.async {
                self.isProfilesListShowing = false
                self.profilesToSave = []
            }
        }
    }
    
    
    func dismissDeleteModal() {
        DispatchQueue.main.async {
            self.isDeleteModalShowing = false
            
            self.profileToDelete = nil
        }
    }
}
