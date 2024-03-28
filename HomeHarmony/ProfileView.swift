//
//  ProfileView.swift
//  Home_Harmony
//
//  Created by Daniel Madjar on 3/25/24.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("Hey \(viewModel.getFirstName())!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                HStack {
                    Text("Email:")
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    Text("\(viewModel.getEmail())")
                }
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.black.opacity(0.75), lineWidth: 3)
                )
                
                Button {
                    signOut()
                } label: {
                    Text("Sign Out")
                        .modifier(ButtonModifier(bgColor: .red, textColor: .white))
                }
                
                Button {
                    deleteAccount()
                } label: {
                    Text("Delete Account")
                        .modifier(ButtonModifier(bgColor: .red, textColor: .white))
                }
            }
            .padding(.horizontal)
        }
    }
    
    private func signOut() {
        viewModel.reset()
        viewModel.signOut()
    }
    
    private func deleteAccount() {
        viewModel.reset()
        
        Task {
           await viewModel.deleteAccount()
        }
    }
}

#Preview {
    ProfileView()
}
