//
//  ProfileView.swift
//  MessagingApp
//
//  Created by Prabesh Shrestha on 11/09/2024.
//

import SwiftUI

struct ProfileView: View {
    @Binding var showSignIn: Bool
    @StateObject private var viewModel = ProfileViewModel()
    var body: some View {
        NavigationStack{
            ScrollView {
                if let user = viewModel.user{
                    if let url = URL(string: user.imageUrl) {
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .frame(width: 150, height: 150)
                                .clipShape(Circle())
                                .padding(.trailing)
                        } placeholder: {
                            ProgressView()
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())
                                .padding(.trailing)
                        }
                    }
                    Text(user.userName.capitalizeFirstLetters())
                    
                
                VStack(alignment: .leading, content: {
                    NavigationLink {
                        ProfileDetailView(showSignIn: $showSignIn, user: user)
                    } label: {
                        HStack{
                            Image(systemName: "person")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .padding(.trailing, 5)
                            VStack(alignment: .leading) {
                                Text("Profile")
                                Text("Change your profile")
                                    .font(.caption)
                                    .foregroundStyle(.gray.opacity(0.5))
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                        .foregroundStyle(.black)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .overlay {
                        RoundedRectangle(cornerRadius: 25)
                            .fill(Color.gray)
                            .opacity(0.1)
                    }
                    
                    NavigationLink {
                        SettingView(user: user,showSignIn: $showSignIn)
                    } label: {
                        HStack{
                            Image(systemName: "gear")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .padding(.trailing, 5)
                            VStack(alignment: .leading) {
                                Text("Settings")
                                Text("Change password")
                                    .font(.caption)
                                    .foregroundStyle(.gray.opacity(0.7))
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                        .foregroundStyle(.black)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .overlay {
                        RoundedRectangle(cornerRadius: 25)
                            .fill(Color.gray)
                            .opacity(0.1)
                    }
                    
                })
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                
            }

        }
            .alert("Logout", isPresented: $viewModel.confirmAlert){
                Button("Yes", role: .destructive){
                    viewModel.signOut()
                }
            }message: {
                Text("Are you sure?")
            }
            .alert("", isPresented: $viewModel.showAlert) {
                Button("OK", role: .cancel){
                    if viewModel.showSignIn{
                        showSignIn = true
                    }else{
                        showSignIn = false
                    }
                }
            } message: {
                Text(viewModel.message)
            }
            .onAppear{
                viewModel.getUser()
            }
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        viewModel.confirmAlert = true
                    } label: {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                            .tint(.red)
                    }
                    
                }
                
            }

        }
    }
}

#Preview {
    ProfileView(showSignIn: .constant(false))
}
