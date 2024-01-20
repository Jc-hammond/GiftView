//
//  GVDatePicker.swift
//  GiftView
//
//  Created by Connor Hammond on 1/7/24.
//

import SwiftUI

struct GVDatePicker: View {
    var title: String
    @Binding var birthdate: Date
    var pickerID: Int
    var onChangeBirthday: () -> Void
    var updateID: () -> Void
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .foregroundStyle(.textFieldBackground)
                .frame(height: 50)
                .padding(.horizontal, 15)
            
            HStack {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(.textBlue)
                    .fontDesign(.rounded)
                    .bold()
                    .padding(.leading, 25)
                
                Spacer()
                DatePicker(title, selection: $birthdate, in: ...Date(), displayedComponents: .date)
                    .datePickerStyle(.compact)
                    .labelsHidden()
                    .padding(.trailing, 25)
                    .id(pickerID)
                    .onChange(of: birthdate) {
                        onChangeBirthday()
                        updateID()
                    }
            }
        }
    }
}
