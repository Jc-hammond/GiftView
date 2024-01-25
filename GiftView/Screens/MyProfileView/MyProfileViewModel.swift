//
//  MyProfileViewModel.swift
//  GiftView
//
//  Created by Connor Hammond on 1/22/24.
//

import Foundation
import SwiftUI

class MyProfileViewModel: ObservableObject {
    @Published var selectedGift: WishGift?
    @Published var isAddGiftShowing = false
    @Published var isShowingImageList: String = "images"
    
    
}
