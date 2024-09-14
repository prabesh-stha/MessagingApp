//
//  ProfileDetailView.swift
//  MessagingApp
//
//  Created by Prabesh Shrestha on 11/09/2024.
//

import SwiftUI
import PhotosUI

struct ProfileDetailView: View {
    @StateObject private var viewModel = ProfileDetailViewModel()
    @Binding var showSignIn: Bool
    
    let user: UserModel
    var body: some View {
        ZStack{
            NavigationStack{
                VStack(alignment: .leading)
                {
                    PhotosPicker(selection: $viewModel.photoPickerItem) {
                        if let image = viewModel.selectedImage{
                            image
                                .resizable()
                                .frame(height: 300)
                                .frame(maxWidth: .infinity)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            
                        }else{
                            Image(systemName: "mountain.2.circle")
                                .resizable()
                                .frame(height: 300)
                                .frame(maxWidth: .infinity)
                                .foregroundStyle(.black)
                            
                            
                        }
                    }.padding(.vertical)
                    CustomTextField(disable: false, title: "Name", text: $viewModel.name)
                        .padding(.bottom,25)
                    CustomTextField(disable: true,title: "Email", text: $viewModel.email)
                        .padding(.bottom, 100)
                    
                    Button {
                        print("hello")
                        viewModel.update(userId: user.userId)
                    } label: {
                        Text("Update")
                            .largeButton(color: Color.cyan)
                    }
                    .disabled(viewModel.disableButton)
                    Spacer()
                }
                .padding()
                .onChange(of: viewModel.photoPickerItem, { oldValue, newValue in
                    viewModel.disableButton = false
                    viewModel.isImageSelected = true
                    viewModel.loadImage()
                })
                .onChange(of: viewModel.name) { oldValue, newValue in
                    if newValue == user.userName{
                        viewModel.disableButton = true
                    }else{
                        viewModel.disableButton = false
                        viewModel.isNameSelected = true
                    }
                }
                .onAppear(perform: {
                    viewModel.loadInfo(user: user)
                })
                .alert("", isPresented: $viewModel.showAlert){
                    Button("OK", role: .cancel){}
                } message: {
                    Text(viewModel.alertMessage)
                }
                .alert("Are you sure", isPresented: $viewModel.showDeleteAlert){
                    Button("Delete", role: .destructive){
                        viewModel.deleteUser(userId: user.userId)
                        showSignIn = true
                    }
                }
                .navigationTitle("\(user.userName.firstName() ?? "Unknown")'s Profile")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button {
                            viewModel.showDeleteAlert = true
                        } label: {
                            Image(systemName: "trash")
                        }
                        .tint(.red)
                        
                    }
                }
                
            }
            if viewModel.showProgressView{
                CustomProgressView()
            }
        }
    }
}

#Preview {
    ProfileDetailView(showSignIn: .constant(false), user: UserModel(userId: "dJAF8Z1cfZfttmkoyoGP8UOqa0g1", userName: "prabesh shrestha", email: "prabesh@gmail.com", imageUrl: "https://firebasestorage.googleapis.com:443/v0/b/passwordmanager-890b8.appspot.com/o/users%2FdJAF8Z1cfZfttmkoyoGP8UOqa0g1%2FPrabesh%20Shrestha?alt=media&token=ab3786de-40d1-44a6-acdf-85545b565463"
                                                                   ))
}
