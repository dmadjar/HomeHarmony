//
//  ContentView.swift
//  Home_Harmony
//
//  Created by Daniel Madjar on 3/18/24.
//

import SwiftUI

struct ButtonModifier: ViewModifier {
    let bgColor: Color
    let textColor: Color
    
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity)
            .foregroundStyle(textColor)
            .padding()
            .background(bgColor)
            .cornerRadius(10)
    }
}

struct TextModifier: ViewModifier {
    let cornerRadius: CGFloat
    let color: Color
    
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity)
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(color, lineWidth: 2)
            )
    }
}

struct LoginView: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @State private var isCreatingAccount: Bool = false
    
    var body: some View {
        ZStack {
            if viewModel.authenticationState == .authenticating {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .black))
                    .padding(.vertical, 8)
                    .frame(maxWidth: .infinity)
            }
            
            VStack(spacing: 45) {
                Spacer()
                
                if !viewModel.errorMessage.isEmpty {
                   VStack {
                     Text("Email or Password is incorrect.")
                           .padding()
                           .background(.red)
                           .foregroundStyle(.white)
                           .cornerRadius(10)
                       
                   }
                 }
                
                Text("HomeHarmony")
                    .font(.largeTitle)
                    .fontWeight(.black)
                
                TextField("Email", text: $viewModel.email)
                    .modifier(TextModifier(cornerRadius: 10, color: .black.opacity(0.25)))
                
                SecureField("Password", text: $viewModel.password)
                    .modifier(TextModifier(cornerRadius: 10, color: .black.opacity(0.25)))
                    
                ButtonComponent(title: "Login", image: nil, color: .red) {
                    signInWithEmailPassword()
                }
                
                Spacer()
                
                VStack(spacing: 15) {
                    HStack {
                        Rectangle()
                            .frame(height: 2)
                        
                        Text("Don't have an account?")
                            .layoutPriority(1)
                        
                        Rectangle()
                            .frame(height: 2)
                    }
                    .opacity(0.5)
                    
                    ButtonComponent(title: "Create Account", image: nil, color: .black.opacity(0.75)) {
                        self.isCreatingAccount = true
                    }
                }
                
                Spacer()
            }
        }
        .padding(24.5)
        .sheet(isPresented: $isCreatingAccount, content: {
            CreateAccount()
        })
    }
    
    private func signInWithEmailPassword() {
        Task {
            await viewModel.signInWithEmailPassword()
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static let viewModel = AuthenticationViewModel()

    static var previews: some View {
        LoginView()
            .environmentObject(viewModel)
    }
}
