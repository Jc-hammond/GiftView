//
//  SettingsView.swift
//  GiftView
//
//  Created by Connor Hammond on 1/22/24.
//

import SwiftUI
import SwiftData

struct SettingsView: View {
    @State private var notificationsOn = false
    @StateObject private var viewModel = SettingsViewModel()
    @FocusState private var focusedField: Field?

    enum Field: Hashable {
        case myField
    }
    
    var body: some View {
        ZStack {
            Form {
                Section {
                    Toggle("Notifications", isOn: $viewModel.notificationsOn)
                    
//                    if viewModel.notificationsOn {
//                        HStack {
//                            Text("Notify me \(viewModel.daysBeforeReminderString) days before")
//                            Spacer()
//                            TextField("Days", text: $viewModel.daysBeforeReminderString)
//                                .focused($focusedField, equals: .myField)
//                                .frame(width: 45)
//                                .multilineTextAlignment(.center)
//                                .keyboardType(.numberPad)
//                                .background(Color.accentColor)
//                                .cornerRadius(10)
//                                .foregroundStyle(.textBlue)
//                        }
//                    }
                }
                .listRowBackground(Color.textFieldBackground)
                
            }
            .scrollContentBackground(.hidden)
            .background(Color.background)
            .tint(.buttonBlue)
//            .alert(isPresented: $viewModel.showAlert) {
//                Alert(title: Text("Notifications Updated"),
//                      message: Text("You will now be reminded \(viewModel.daysBeforeReminder) days before a birthday."),
//                      dismissButton: .default(Text("OK")))
//            }
            
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.large)
        .onChange(of: viewModel.notificationsOn) {
            viewModel.toggleNotifications()
        }
//        .onSubmit(of: .text) {
//            viewModel.onSubmitNewDays()
//        }
//        .modifier(DismissingKeyboard())
//        .toolbar {
//            ToolbarItem(placement: .keyboard) {
//                HStack {
//                    Spacer()
//                    Button("Done") {
//                        focusedField = nil
//                        viewModel.onSubmitNewDays()
//                    }
//                }
//            }
//        }
    }
}
