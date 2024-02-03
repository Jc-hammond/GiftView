//
//  AddProfileModalView.swift
//  GiftView
//
//  Created by Connor Hammond on 11/6/23.
//

import SwiftUI
import SwiftData
import PhotosUI
import Contacts

struct AddProfileModalView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    
    @StateObject var viewModel = AddProfileModalViewModel()
    
    @Binding var profile: Profile
    var onCommit: (Profile) -> Void
    
    @State private var profilesToSave: [Profile] = []
    @State private var isProfilesListShowing = false
    
    @State var isPickerPresented = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.background).ignoresSafeArea()
                VStack {
                    GVPhotoPicker(
                        photoSelection: $viewModel.selectedAvatar,
                        avatarData: viewModel.avatarData,
                        photoOnAppear: viewModel.handleErrors,
                        placeholderOnChange: viewModel.handleErrors
                    )
                    .onAppear(perform: {
                        if profile.avatar != nil {
                            DispatchQueue.main.async {
                                viewModel.avatarData = profile.avatar
                            }
                        }
                    })
                    .padding(.top, 45)
                    
                    VStack(spacing: 30) {
                        
                        Text("Create Profile")
                            .font(.title)
                            .foregroundStyle(.textBlue)
                            .fontDesign(.rounded)
                            .bold()
                        
                        GVTextField(title: "Full Name",
                                    prompt: Text("Full Name"),
                                    text: $profile.name)
                        .onAppear(perform: {
                            if !profile.name.isEmpty {
                                DispatchQueue.main.async {
                                    viewModel.name = profile.name
                                }
                            }
                        })
                        .onChange(of: profile.name) { _, _ in
                            DispatchQueue.main.async {
                                viewModel.name = profile.name
                                viewModel.handleErrors()
                            }
                        }
                        
                        GVDatePicker(title: "Birthdate",
                                     birthdate: $profile.birthdate,
                                     pickerID: viewModel.datePickerId,
                                     onChangeBirthday: {
                            viewModel.updateBirthdate(
                                newDate: profile.birthdate
                            )
                        },
                                     updateID: {
                            viewModel.datePickerId += 1
                        })
                        
                        GVPrimaryButton(buttonAction: {await viewModel.save(profile: profile, onCommit: {onCommit(profile)})},
                                        title: viewModel.saveButtonTitle,
                                        imageString: viewModel.saveButttonImage,
                                        isDisabled: viewModel.formIsBlank)
                        .disabled(viewModel.formIsBlank)
                        
                    }
                    
                    if viewModel.displayError {
                        GVErrorMessage(message: viewModel.errorMessage)
                    }
                    
                    Spacer()
                }
                
            }
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
                    .padding()
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Done")
                            .foregroundStyle(viewModel.saveButtonTitle == "Saved" ? .buttonBlue : .clear)
                            .fontDesign(.rounded)
                            .bold()
                    }
                    .padding()
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
        }
        .navigationBarBackButtonHidden()
    }
}
