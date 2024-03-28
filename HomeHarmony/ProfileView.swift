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
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
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
                    
                    ButtonComponent(title: "Sign Out", image: nil, color: .red) {
                        signOut()
                    }
                    
                    ButtonComponent(title: "Delete Account", image: nil, color: .red) {
                        deleteAccount()
                    }
                }
                .padding(.horizontal)
            }
            .navigationTitle("Hey \(viewModel.getFirstName())!")
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
