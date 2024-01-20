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
    @Attribute(.unique) var title: String
    var image: Data?
    var link: String?
    var isPurchased: Bool = false
    
    @Relationship(deleteRule: .nullify, inverse: \Profile.gifts)
    var profile: Profile?
    
    init(title: String, image: Data? = nil, link: String? = nil, profile: Profile? = nil) {
        self.title = title
        self.image = image
        self.link = link
        self.profile = profile
    }
}
