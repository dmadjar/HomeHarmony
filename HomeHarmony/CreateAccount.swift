//
//  CreateAccount.swift
//  Home_Harmony
//
//  Created by Daniel Madjar on 3/18/24.
//

import SwiftUI

struct CreateAccount: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Spacer()
            
            VStack(alignment: .leading, spacing: 35) {
                Text("Create Account")
                    .font(.largeTitle)
                    .fontWeight(.black)
                
                TextField("First Name", text: $viewModel.firstName)
                    .modifier(TextModifier(cornerRadius: 10, color: .black.opacity(0.25)))
                
                TextField("Last Name", text: $viewModel.lastName)
                    .modifier(TextModifier(cornerRadius: 10, color: .black.opacity(0.25)))
                
                TextField("Email", text: $viewModel.email)
                    .modifier(TextModifier(cornerRadius: 10, color: .black.opacity(0.25)))
                
                SecureField("Password", text: $viewModel.password)
                    .modifier(TextModifier(cornerRadius: 10, color: .black.opacity(0.25)))
                
                SecureField("Confirm Passoword", text: $viewModel.confirmPassword)
                    .modifier(TextModifier(cornerRadius: 10, color: .black.opacity(0.25)))
                
                ButtonComponent(title: "Create Account", image: nil, color: .red) {
                    signUpWithEmailPassword()
                }
            }
            
            Spacer()
        }
        .padding(24.5)
    }
    
    private func signUpWithEmailPassword() {
        Task {
            if await viewModel.signUpWithEmailPassword() {
                dismiss()
            }
        }
    }
}

struct CreateAccount_Previews: PreviewProvider {
    static let viewModel = AuthenticationViewModel()

    static var previews: some View {
        CreateAccount()
            .environmentObject(viewModel)
    }
}


