//
//  AddProfileView.swift
//  GiftView
//
//  Created by Connor Hammond on 8/13/23.
//

import SwiftUI
import SwiftData
import PhotosUI
import Contacts

struct AddProfileView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    
    @StateObject private var viewModel = AddProfileViewModel()
    
    var body: some View {
        ZStack {
            Color(.background).ignoresSafeArea()
            VStack {
                GVPhotoPicker(
                    photoSelection: $viewModel.selectedAvatar,
                    avatarData: viewModel.avatarData,
                    photoOnAppear: viewModel.handleErrors,
                    placeholderOnChange: viewModel.handleErrors
                )
                
                VStack(spacing: 30) {
                    
                    Text("Create Profile")
                        .font(.title)
                        .foregroundStyle(.textBlue)
                        .fontDesign(.rounded)
                        .bold()
                    
                    
                    GVTextField(title: "Full Name",
                                prompt: Text("Full Name"),
                                text: $viewModel.name)
                    .onChange(of: viewModel.name) {
                        viewModel.handleErrors()
                    }
                    
                    GVDatePicker(title: "Birthdate",
                                 birthdate: $viewModel.birthdate,
                                 pickerID: viewModel.datePickerId,
                                 onChangeBirthday: {
                        viewModel.updateBirthdate(
                            newDate: viewModel.birthdate
                        )
                    },
                                 updateID: {
                        viewModel.datePickerId += 1
                    })
                    
                    GVPrimaryButton(buttonAction: {
                        let newProfile =  await viewModel.addNewProfile(name: viewModel.name,
                                                                        birthdate: viewModel.birthdate,
                                                                        avatar: viewModel.avatarData)
                        modelContext.insert(newProfile)
                    },
                                    title: "Add Profile",
                                    imageString: "plus.circle",
                                    isDisabled: viewModel.formIsBlank,
                                    shouldDismiss: true)
                    .disabled(viewModel.formIsBlank)
                    
                }
                
                if viewModel.displayError {
                    GVErrorMessage(message: viewModel.errorMessage)
                }
                
                Spacer()
            }
            
        }
            .navigationBarTitleDisplayMode(.inline)
            .dismissingKeyboardIfNeeded()
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        viewModel.resetForm()
                        dismiss()
                    } label: {
                        Text("Cancel")
                            .foregroundStyle(.buttonBlue)
                            .fontDesign(.rounded)
                            .bold()
                    }
                }
            }
        
            .onDisappear(perform: {
                if viewModel.formIsBlank {
                    return
                } else {
                    viewModel.resetForm()
                    
                }
            })
            .task(id: viewModel.selectedAvatar) {
                await viewModel.convertPhotoToData()
            }
            .navigationBarBackButtonHidden()
    }
}
