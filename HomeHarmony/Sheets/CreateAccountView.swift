//
//  CreateAccount.swift
//  Home_Harmony
//
//  Created by Daniel Madjar on 3/18/24.
//

import SwiftUI
import PhotosUI

struct CreateAccountView: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @StateObject var imagePicker = ImagePickerViewModel()
    @Environment(\.dismiss) var dismiss
    @State private var selectingPhoto = false
    
    var body: some View {
        VStack {
            Spacer()
            
            VStack(alignment: .leading, spacing: 35) {
                Text("Create Account")
                    .font(.custom("Sansita-ExtraBold", size: 36))
                
                TextFieldComponent(text: $viewModel.firstName, title: "First Name", image: "pencil", isSecure: false)
                
                TextFieldComponent(text: $viewModel.lastName, title: "Last Name", image: "pencil", isSecure: false)
                
                TextFieldComponent(text: $viewModel.email, title: "Email", image: "mail.fill", isSecure: false)
                
                TextFieldComponent(text: $viewModel.password, title: "Password", image: "lock.fill", isSecure: true)
                
                TextFieldComponent(text: $viewModel.confirmPassword, title: "Confirm Password", image: "checkmark", isSecure: true)
                
                HStack {
                    Text("Profile Photo")
                    
                    Spacer()
                    
                    PhotosPicker(selection: $imagePicker.imageSelection) {
                        if let image = imagePicker.image {
                            image
                                .resizable()
                                .frame(width: 50, height: 50)
                                .scaledToFit()
                        } else {
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .frame(width: 50, height: 50)
                        }
                    }
                }
                .padding()
                .foregroundStyle(Color("textColor"))
                .font(.custom("Sansita-Bold", size: 17))
                .background(Color("secondaryColor"))
                .cornerRadius(10)
                
                ButtonComponent(title: "Create Account", image: nil, backgroundColor: Color("blueColor"), textColor: Color("defaultColor")) {
                    signUpWithEmailPassword()
                }
            }
            
            Spacer()
        }
        .padding(24.5)
        .background(Color("backgroundColor"))
    }
    
    private func signUpWithEmailPassword() {
        Task {
            if await viewModel.signUpWithEmailPassword() {
                if let userId = viewModel.user?.uid {
                    imagePicker.uploadImage(user_id: userId)
                }
                dismiss()
            }
        }
    }
}

struct CreateAccount_Previews: PreviewProvider {
    static let viewModel = AuthenticationViewModel()

    static var previews: some View {
        CreateAccountView()
            .environmentObject(viewModel)
    }
}


