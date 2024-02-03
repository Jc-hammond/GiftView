//
//  View+Ext.swift
//  GiftView
//
//  Created by Connor Hammond on 2/2/24.
//

import SwiftUI

extension View {
    @ViewBuilder
    func dismissingKeyboardIfNeeded() -> some View {
        if #available(iOS 17, *) {
            self.modifier(DismissingKeyboard())
        } else {
            self.modifier(EmptyModifier())
        }
        
    }
}

struct EmptyModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .onTapGesture {
                return
            }
    }
}
