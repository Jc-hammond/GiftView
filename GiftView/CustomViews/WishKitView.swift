//
//  WishKitView.swift
//  GiftView
//
//  Created by Connor Hammond on 1/12/24.
//

import SwiftUI
#if canImport(WishKit) && os(iOS)
import WishKit
#endif

struct WishKitView: View {
    var body: some View {
#if os(iOS)
        WishKit.view
#endif
        
#if os(visionOS)
        EmptyView()
#endif
    }
}

#Preview {
    WishKitView()
}
