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
                    
                    VStack(spacing: 30) {
                        
                        Text("Create Profile")
                            .font(.title)
                            .foregroundStyle(.textBlue)
                            .fontDesign(.rounded)
                            .bold()
                        
                        //TODO: Seperate out first and last name everywhere
                        //GVTextField(title: "First Name",
                        //                  prompt: Text("First Name"),
                        //                  text: $viewModel.firstName)
                        //                    .onChange(of: viewModel.firstName) {
                        //                       if viewModel.birthdateChanged {
                        //                           viewModel.handleErrors()
                        //                      }
                        //                    }
                        
                        
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
                        
                        GVPrimaryButton(buttonAction: {viewModel.addNewProfile(name: viewModel.name,
                                                                               birthdate: viewModel.birthdate,
                                                                               avatar: viewModel.avatarData,
                                                                               modelContext: modelContext)},
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
                
            }.navigationBarTitleDisplayMode(.inline)
            
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
        }
        .navigationBarBackButtonHidden()
    }
        
}
