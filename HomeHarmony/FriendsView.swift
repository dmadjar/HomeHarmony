//
//  FriendsView.swift
//  Home_Harmony
//
//  Created by Daniel Madjar on 3/18/24.
//

import SwiftUI

struct FriendsView: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    
    @State private var search: String = ""
    @State private var isAddingFriend: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                if !viewModel.friendRequests.isEmpty {
                    Text("Requests")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    ForEach(viewModel.friendRequests) { request in
                        HStack(spacing: 5) {
                            Text(request.firstName)
                            
                            Text(request.lastName)
                            
                            Spacer()
                            
                            Button {
                                Task {
                                    await viewModel.declineRequest(requestId: request.id)
                                }
                            } label: {
                                Image(systemName: "x.circle.fill")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .foregroundStyle(.red)
                            }
                            
                            Button {
                                Task {
                                    await viewModel.acceptRequest(requestId: request.id)
                                }
                            } label: {
                                Image(systemName: "checkmark.circle.fill")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .foregroundStyle(.green)
                            }
                        }
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.black, lineWidth: 3)
                        )
                    }
                }
            }
            .padding(.horizontal)
                
            VStack(alignment: .leading, spacing: 15) {
                Text("Friends")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                ForEach(viewModel.friends) { friend in
                    HStack(spacing: 5) {
                        Text(friend.firstName)
                        
                        Text(friend.lastName)
                        
                        Spacer()
                    }
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.black, lineWidth: 3)
                    )
                }
            }
            .padding(.horizontal)
        }
        .safeAreaInset(edge: .bottom) {
            Button {
                Task {
                    await viewModel.getAllUsersNotFriends()
                    
                    self.isAddingFriend = true
                }
            } label: {
                Text("Add Friend")
                    .modifier(ButtonModifier(bgColor: .red, textColor: .white))
            }
            .padding()
        }
        .sheet(isPresented: $isAddingFriend) {
            AddFriendView(isAddingFriend: $isAddingFriend)
        }
    }
}

struct FriendsView_Previews: PreviewProvider {
    static var previews: some View {
        FriendsView()
    }
}
