//
//  MakeAWishTip.swift
//  GiftView
//
//  Created by Connor Hammond on 1/12/24.
//

import SwiftUI
import TipKit

struct MakeAWishTip: Tip {
    var title: Text {
        Text("Have an idea for GiftView?")
    }
    
    var message: Text? {
        Text("Tap here to request a feature")
    }
    
    var image: Image? {
        Image(systemName: "sparkles")
    }
    
}
