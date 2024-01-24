//
//  GVPrimaryButton.swift
//  GiftView
//
//  Created by Connor Hammond on 1/7/24.
//

import SwiftUI

struct GVPrimaryButton: View {
    @Environment(\.dismiss) private var dismiss
    var buttonAction: () async -> Void
    var title: String
    var imageString: String
    var isDisabled: Bool
    var shouldDismiss: Bool = false
    
    var body: some View {
        Button {
            Task {
                await buttonAction()
            }
            if shouldDismiss {
                dismiss()
            }
        } label: {
            Label(title, systemImage: imageString)
                .font(.title2)
                .fontDesign(.rounded)
                .bold()
                .padding(EdgeInsets(top: 12, leading: 110, bottom: 12, trailing: 110))
                .foregroundStyle(.white)
                .background(isDisabled ? .buttonBlue.opacity(0.25) : .buttonBlue)
                .clipShape(Capsule())
        }
    }
}

#Preview {
    GVPrimaryButton(buttonAction: {print("pressed")},
                    title: "Save Profile",
                    imageString: "checkmark.circle",
                    isDisabled: false)
}
