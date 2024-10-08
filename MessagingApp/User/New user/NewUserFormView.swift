//
//  NewUserFormView.swift
//  MessagingApp
//
//  Created by Prabesh Shrestha on 09/09/2024.
//

import SwiftUI
import PhotosUI

struct NewUserFormView: View {
    @FocusState var focusEmail: Bool
    
    @StateObject private var viewModel = NewUserFormViewModel()
    @Binding var showSignIn: Bool
    var body: some View {
        ZStack{
            NavigationStack{
                ScrollView{
                    VStack(alignment: .leading){
                        if let imageError = viewModel.imageError{
                            Text(imageError)
                                .font(.caption)
                                .foregroundStyle(.red)
                        }
                        
                        PhotosPicker(selection: $viewModel.photoPickerItem) {
                            if let image = viewModel.selectedImage{
                                image
                                    .resizable()
                                    .frame(width: 300, height: 300)
                                    .clipShape(Circle())
                            }else{
                                Image(systemName: "mountain.2.circle")
                                    .resizable()
                                    .frame(width: 300, height: 300)
                                    .foregroundStyle(.black)
                                
                                
                            }
                        }.padding(.bottom, 30)
                        if let emailError = viewModel.emailError{
                            Text(emailError)
                                .font(.caption)
                                .foregroundStyle(.red)
                        }
                        CustomTextFieldWithIcon(text: $viewModel.email, icon: "envelope", placeholder: "Email")
                            .padding(.bottom, 30)
                            .focused($focusEmail)
                            .onChange(of: focusEmail) { oldValue, newValue in
                                if !newValue{
                                    viewModel.checkExisitingEmail()
                                }
                            }
                        if let passwordError = viewModel.passwordError{
                                Text(passwordError)
                                    .font(.caption)
                                    .foregroundStyle(.red)
                            }
                        CustomSecureFiled(text: $viewModel.password, icon: "lock", placeholder: "Password")
                            .padding(.bottom, 30)
                        if let nameError = viewModel.nameError{
                            Text(nameError)
                                .font(.caption)
                                .foregroundStyle(.red)
                        }
                        CustomTextFieldWithIcon(text: $viewModel.userName, icon: "person", placeholder: "User Name")
                            .padding(.bottom, 30)
                        
                        Button {
                            Task{
                                showSignIn = try await !viewModel.signUp()
                            }
                        } label: {
                            Text("Sign Up")
                                .largeButton(color: Color.cyan)
                        }
                        
                        
                        
                    }
                    .onChange(of: viewModel.photoPickerItem, { oldValue, newValue in
                        viewModel.loadImage()
                    })
                    .padding()
                    .navigationTitle("Sign Up")
                }
                
            }
            if viewModel.showProgressView{
                CustomProgressView()
            }
        }
    }
}

#Preview {
    NewUserFormView(showSignIn: .constant(false))
}
