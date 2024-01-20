//
//  GVErrorMessage.swift
//  GiftView
//
//  Created by Connor Hammond on 1/7/24.
//

import SwiftUI

struct GVErrorMessage: View {
    var message: String
    var body: some View {
        Text(message)
            .foregroundStyle(Color.errorRed)
            .fontDesign(.rounded)
            .bold()
            .padding()
    }
}

#Preview {
    GVErrorMessage(message: "Please select an avatar to continue")
}
