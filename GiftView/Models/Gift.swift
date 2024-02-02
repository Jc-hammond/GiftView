//
//  Gift.swift
//  GiftView
//
//  Created by Connor Hammond on 8/13/23.
//

import Foundation
import SwiftData

@Model
final class Gift {
    @Attribute(.unique) var id: UUID = UUID()
    @Attribute(.unique) var title: String
    var image: Data?
    var link: String?
    var isPurchased: Bool = false
    
    @Relationship(deleteRule: .nullify, inverse: \Profile.gifts)
    var profile: Profile?
    
    init(id: UUID = UUID(), title: String, image: Data? = nil, link: String? = nil, profile: Profile? = nil) {
        self.id = id
        self.title = title
        self.image = image
        self.link = link
        self.profile = profile
    }
}

@Model
final class WishGift {
    @Attribute(.unique) var id: UUID = UUID()
    @Attribute(.unique) var title: String
    var image: Data?
    var link: String?
    var isPurchased: Bool = false
    
    @Relationship(deleteRule: .nullify, inverse: \MyProfile.gifts)
    var myProfile: MyProfile?
    
    init(id: UUID = UUID(), title: String, image: Data? = nil, link: String? = nil, myProfile: MyProfile? = nil) {
        self.id = id
        self.title = title
        self.image = image
        self.link = link
        self.myProfile = myProfile
    }
}
