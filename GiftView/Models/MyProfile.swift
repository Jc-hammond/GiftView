//
//  MyProfile.swift
//  GiftView
//
//  Created by Connor Hammond on 1/22/24.
//

import Foundation
import SwiftData

@Model
final class MyProfile: ObservableObject, Identifiable {
    @Attribute(.unique) var id: UUID
    var name: String = ""
    var birthdate: Date
    @Attribute(.externalStorage) var avatar: Data?
    
    var formattedName: String {
            guard let spaceIndex = name.firstIndex(of: " ") else { return name }
            
            var modifiedName = name
            modifiedName.remove(at: spaceIndex)
            modifiedName.insert("\n", at: spaceIndex)
            
            return modifiedName
        }

    init(name: String, birthdate: Date, avatar: Data? = nil, gifts: [WishGift] = []) {
        self.id = UUID()
        self.name = name
        self.birthdate = birthdate
        self.gifts = gifts
        self.avatar = avatar
    }
    
    @Relationship(deleteRule: .cascade)
    var gifts: [WishGift]?
}
