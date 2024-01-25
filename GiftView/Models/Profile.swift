//
//  Profile.swift
//  GiftView
//
//  Created by Connor Hammond on 8/13/23.
//

import Foundation
import SwiftData

@Model
final class Profile: ObservableObject, Identifiable {
    @Attribute(.unique) var id: UUID
    var name: String
    var birthdate: Date
    @Attribute(.externalStorage) var avatar: Data?
    var hasNotifications: Bool = true
    
    var formattedName: String {
            guard let spaceIndex = name.firstIndex(of: " ") else { return name }
            
            var modifiedName = name
            modifiedName.remove(at: spaceIndex)
            modifiedName.insert("\n", at: spaceIndex)
            
            return modifiedName
        }
    
    init(name: String, birthdate: Date, avatar: Data? = nil, gifts: [Gift] = [], hasNotifications: Bool = true ){
        self.id = UUID()
        self.name = name
        self.birthdate = birthdate
        self.avatar = avatar
        self.gifts = gifts
        self.hasNotifications = hasNotifications
    }
    
    @Relationship(deleteRule: .cascade)
    var gifts: [Gift]?
    
}

struct ProfileMockData {
    static let shared = ProfileMockData()
    let profiles = [
        Profile(name: "Edward Stone", birthdate: .distantPast),
        Profile(name: "Samantha Jones", birthdate: .distantPast),
        Profile(name: "Charlie Rutherford", birthdate: .distantPast),
        Profile(name: "Jon Dow", birthdate: .distantPast),
        Profile(name: "Xavier Wheelie", birthdate: .distantPast),
    ]
}
