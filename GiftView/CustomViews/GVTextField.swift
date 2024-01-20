//
//  GVTextField.swift
//  GiftView
//
//  Created by Connor Hammond on 1/7/24.
//

import SwiftUI

struct GVTextField: View {
    var title: String
    var prompt: Text
    var text: Binding<String>
    var body: some View {
        TextField(title, text: text,prompt: prompt.foregroundStyle(.textBlue.opacity(0.5)))
            .autocorrectionDisabled()
            .tint(.searchBackground)
            .foregroundStyle(.textBlue)
            .padding(.horizontal, 25)
            .padding(.vertical, 15)
            .background {
                RoundedRectangle(cornerRadius: 25)
                    .padding(.horizontal, 15)
            }
            .foregroundStyle(.textFieldBackground)
    }
}

#Preview {
    GVTextField(title: "Full Name", prompt: Text("Full Name"), text: .constant("Text"))
}
