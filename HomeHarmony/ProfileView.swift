//
//  ProfileView.swift
//  Home_Harmony
//
//  Created by Daniel Madjar on 3/25/24.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    
    @State private var showFriends: Bool = false
    @State private var isAddingFriend: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 15) {
                HStack {
                    Text("Email:")
                    
                    Spacer()
                    
                    Text("\(viewModel.getEmail())")
                }
                .padding()
                .font(.custom("Sansita-Bold", size: 17))
                .background(Color("secondaryColor"))
                .cornerRadius(10)
                
                HStack {
                    Text("Enable Dark Mode")
                    
                    Spacer()
                    
                    Toggle("", isOn: $viewModel.isDarkMode)
                        .tint(Color("blueColor"))
                }
                .padding()
                .font(.custom("Sansita-Bold", size: 17))
                .background(Color("secondaryColor"))
                .cornerRadius(10)
                
                HStack {
                    Button {
                        self.showFriends.toggle()
                    } label: {
                        Text("See Friends")
                            
                        Image(systemName: "chevron.down")
                            .bold()
                    }
                    .font(.custom("Sansita-Bold", size: 17))
            
                    Spacer()
                    
                    Button {
                        Task {
                            await viewModel.getAllUsersNotFriends()
                            self.isAddingFriend = true
                        }
                    } label: {
                        HStack {
                            Image(systemName: "plus")
                            
                            Text("Add")
                        }
                        .font(.custom("Sansita-Bold", size: 17))
                        .foregroundStyle(Color("defaultColor"))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color("textColor"))
                        .cornerRadius(5)
                    }
                }
                .padding()
                .background(Color("secondaryColor"))
                .cornerRadius(10)
                
                if showFriends {
                    ScrollView {
                        FriendsView()
                    }
                }
                
                Spacer()
                
                ButtonComponent(title: "Sign Out", image: nil, backgroundColor: Color("blueColor"), textColor: Color("blackColor")) {
                    signOut()
                }
                
                ButtonComponent(title: "Delete Account", image: nil, backgroundColor: Color("secondaryColor"), textColor: Color("redColor")) {
                    deleteAccount()
                }
            }
            .padding()
            .transition(.move(edge: .top))
            .animation(.easeInOut, value: showFriends)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color("backgroundColor"))
            .safeAreaInset(edge: .top) {
                NavBarComponent(
                    search: .constant(""),
                    title: "Hey \(viewModel.getFirstName())!",
                    content: {
                        if let profilePic = viewModel.profilePicture {
                            profilePic
                                .resizable()
                                .frame(width: 50, height: 50)
                                .scaledToFit()
                                .cornerRadius(30)
                        }
                    }
                )
            }
        }
        .sheet(isPresented: $isAddingFriend) {
            AddFriendView(isAddingFriend: $isAddingFriend)
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

struct ProfileView_Previews: PreviewProvider {
    static let viewModel = AuthenticationViewModel()

    static var previews: some View {
        ProfileView()
            .environmentObject(viewModel)
    }
}
