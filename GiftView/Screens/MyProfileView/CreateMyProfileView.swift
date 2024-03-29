//
//  CreateMyProfileView.swift
//  GiftView
//
//  Created by Connor Hammond on 1/22/24.
//

import SwiftUI

struct CreateMyProfileView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    
    @StateObject var viewModel = CreateMyProfileViewModel()
    
    @Binding var path: [Profile]
    
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
                    
                    GVSecondaryButton(buttonAction: {
                        viewModel.addNewProfile(name: viewModel.name,
                                                birthdate: viewModel.birthdate,
                                                avatar: viewModel.avatarData,
                                                modelContext: modelContext)},
                                      title: "Create My Profile",
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
        .onAppear(perform: {
            print(path)
        })
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

#Preview {
    CreateMyProfileView(path: .constant([]))
}
