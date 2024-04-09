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
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 15) {
                    if viewModel.friendsLoading {
                        ForEach(0..<5) { _ in
                            ShimmerView()
                                .frame(height: 100)
                                .cornerRadius(10)
                        }
                    } else {
                        VStack(alignment: .leading, spacing: 15) {
                            ForEach(friendResults) { friend in
                                HStack(spacing: 5) {
                                    Text(friend.firstName)
                                    
                                    Text(friend.lastName)
                                    
                                    Spacer()
                                }
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundStyle(.black)
                                .padding()
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(.black.opacity(0.15), lineWidth: 2)
                                )
                            }
                        }
                        
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
                                        .stroke(.black, lineWidth: 2)
                                )
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
            .navigationTitle("Friends")
            .searchable(text: $search)
        }
        .safeAreaInset(edge: .bottom) {
            ButtonComponent(title: "Add Friend", image: nil) {
                Task {
                    await viewModel.getAllUsersNotFriends()
                    self.isAddingFriend = true
                }
            }
            .padding()
        }
        .sheet(isPresented: $isAddingFriend) {
            AddFriendView(isAddingFriend: $isAddingFriend)
        }
    }
    
    var friendResults: [CustomUser] {
        if search.isEmpty {
            return viewModel.friends
        } else {
            return viewModel.friends.filter { $0.firstName.contains(search) }
        }
    }
}

struct FriendsView_Previews: PreviewProvider {
    static var previews: some View {
        FriendsView()
    }
}
