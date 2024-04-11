//
//  ContentView.swift
//  Home_Harmony
//
//  Created by Daniel Madjar on 3/18/24.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @Environment(\.colorScheme) private var colorScheme
    @State private var isCreatingAccount: Bool = false
    
    var body: some View {
        ZStack {
            Color("backgroundColor")
                .ignoresSafeArea()
            
            VStack {
                CheckmarkView(isReversed: false)
                
                Spacer()
                
                CheckmarkView(isReversed: true)
            }
            .frame(width: UIScreen.main.bounds.width)
            .ignoresSafeArea()
            
            if viewModel.authenticationState == .authenticating {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .black))
                    .padding(.vertical, 8)
                    .frame(maxWidth: .infinity)
            }
            
            VStack(spacing: 60) {
                Text("HomeHarmony")
                    .font(.custom("Sansita-ExtraBold", size: 42))
                
                Group {
                    VStack {
                        HStack {
                            Image(systemName: "person.fill")
                                .font(.system(size: 20))
                            
                            TextField("Email", text: $viewModel.email)
                                .font(.custom("Sansita-Bold", size: 20))
                        }
                        
                        RoundedRectangle(cornerRadius: 10)
                            .frame(height: 2)
                    }
                    
                    VStack {
                        HStack {
                            Image(systemName: "lock.fill")
                                .font(.system(size: 20))
                            
                            SecureField("Password", text: $viewModel.password)
                                .font(.custom("Sansita-Bold", size: 20))
                        }
                        
                        RoundedRectangle(cornerRadius: 10)
                            .frame(height: 2)
                    }
                    
                    VStack(spacing: 20) {
                        Button {
                            signInWithEmailPassword()
                        } label: {
                            Text("Login")
                                .frame(maxWidth: .infinity)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 15)
                                .font(.custom("Sansita-Bold", size: 20))
                                .foregroundStyle(Color("defaultColor"))
                                .background(Color("textColor"))
                                .cornerRadius(10)
                                .shadow(color: .black.opacity(0.10), radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/, x: 0, y: 5)
                        }
                        
                        HStack {
                            Text("Don't have an account?")
                            
                            Button {
                                self.isCreatingAccount = true
                            } label: {
                                Text("Register")
                                    .underline()
                            }
                        }
                        .font(.custom("Sansita-Regular", size: 15))
                    }
                }
                .foregroundStyle(Color("textColor")
                    .opacity(colorScheme == .dark ? 0.25 : 0.5)
                )
                .padding(.horizontal, 60)
                
                Spacer()
                    .frame(height: 20)
            }
        }
        .sheet(isPresented: $isCreatingAccount, content: {
            CreateAccountView()
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
