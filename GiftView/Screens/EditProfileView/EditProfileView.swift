//
//  EditProfileView.swift
//  GiftView
//
//  Created by Connor Hammond on 8/21/23.
//

import SwiftUI
import SwiftData
import PhotosUI

struct EditProfileView: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject private var reviewManager: RequestReviewManager
    @Environment(\.dismiss) var dismiss
    
    @StateObject var viewModel = EditProfileViewModel()
    
    @Binding var profile: Profile
        
    @State private var isProfilesListShowing = false
    
    @State var isPickerPresented = false
    
    @Binding var path: [Profile]
                        
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.background).ignoresSafeArea()
                VStack {
                    HStack {
                        Spacer()
                        PhotosPicker(selection: $viewModel.selectedAvatar, matching: .images) {
                            if let photoData = profile.avatar  {
                                let uiImage = UIImage(data: photoData)
                                Image(uiImage: uiImage!)
                                    .resizable()
                                    .scaledToFill()
                                    .clipShape(Circle())
                                    .frame(width: 135, height: 135)
                                    .clipped()
                                    .padding()
                                    
                            } else if let photoData = viewModel.avatarData {
                                let uiImage = UIImage(data: photoData)
                                Image(uiImage: uiImage!)
                                    .resizable()
                                    .scaledToFill()
                                    .clipShape(Circle())
                                    .frame(width: 135, height: 135)
                                    .clipped()
                                    .padding()
                                    
                            } else {
                                Image(systemName: "person.crop.circle.badge.plus")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundStyle(.buttonBlue)
                                    .frame(width: 135, height: 135)
                                    .clipShape(Circle())
                                    .padding()
                                    .offset(x: -5)
                            }
                        }
                        
                        Spacer()
                    }
                    
                    VStack(spacing: 30) {
                        
                        Text("Edit Profile")
                            .font(.title)
                            .foregroundStyle(.textBlue)
                            .fontDesign(.rounded)
                            .bold()
                        
                        TextField("Full Name", text: $profile.name)
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
                            .onAppear(perform: {
                                viewModel.name = profile.name
                            })
                            .onChange(of: profile.name) { oldValue, newValue in
                                viewModel.checkForNameChange(name: newValue)
                            }
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 25)
                                .foregroundStyle(.textFieldBackground)
                                .frame(height: 50)
                                .padding(.horizontal, 15)
                            
                            HStack {
                                Text("Birthdate")
                                    .font(.headline)
                                    .foregroundStyle(.textBlue)
                                    .fontDesign(.rounded)
                                    .bold()
                                    .padding(.leading, 25)
                                
                                Spacer()
                                DatePicker("Birthdate", selection: $profile.birthdate, displayedComponents: .date)
                                .datePickerStyle(.compact)
                                .labelsHidden()
                                .padding(.trailing, 25)
                                .id(viewModel.datePickerId)
                                .onAppear(perform: {
                                    viewModel.birthdate = profile.birthdate
                                })
                                .onChange(of: profile.birthdate) { oldValue, newValue in
                                    viewModel.checkForBirthdateUpdate(birthdate: newValue)
                                    viewModel.datePickerId += 1
                                }

                            }
                        }
                       
                        
                        Button {
                            viewModel.saveButtonPressed(profile: profile)
                            dismiss()
                        } label: {
                            Label(viewModel.saveButtonTitle, systemImage: viewModel.saveButttonImage)
                                .font(.title2)
                                .fontDesign(.rounded)
                                .bold()
                                .padding(EdgeInsets(top: 12, leading: 90, bottom: 12, trailing: 90))
                                .foregroundStyle(.white)
                                .background(!viewModel.formIsUpdated ? .buttonBlue.opacity(0.5) : .buttonBlue)
                                .clipShape(Capsule())
                                .lineLimit(1)
                        }
                        .disabled(!viewModel.formIsUpdated)
                        
                        GVDestructiveButton(buttonAction: { viewModel.isDeleteModalShowing = true},
                                            title: "Delete Profile?",
                                            imageString: "x.circle",
                                            isDisabled: false)
                        
                    }
                    Spacer()
                }
                
            }
            .alert("Delete \(profile.name)?", isPresented: $viewModel.isDeleteModalShowing) {
                Button("Delete", role: .destructive) {
                    deleteAndDismiss(profile: profile)
                    reviewManager.subtractOne()
                }
                
                Button("Cancel", role: .cancel) {
                    DispatchQueue.main.async {
                        viewModel.isDeleteModalShowing = false
                    }
                }
            } message: {
                Text("You cannot undo this action.")
            }
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
            }
            .onDisappear(perform: {
                if viewModel.formIsBlank {
                    return
                } else {
                    viewModel.resetForm()
                }
            })
            .task(id: viewModel.selectedAvatar) {
                await viewModel.convertPhotoToData(for: profile)
            }
        }
        .navigationBarBackButtonHidden()
        .onAppear {
            print(path.count)
        }
    }
    
    private func deleteAndDismiss(profile: Profile) {
        DispatchQueue.main.async {
            modelContext.delete(profile)
            viewModel.isDeleteModalShowing = false
        }
        //Resets navigation back to root view (ProfilesView)
        path = []
    }
}
