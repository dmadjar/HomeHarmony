//
//  AddFriendView.swift
//  Home_Harmony
//
//  Created by Daniel Madjar on 3/18/24.
//

import SwiftUI

struct AddFriendView: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @Binding var isAddingFriend: Bool
    
    @State private var search: String = ""
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 15) {
                    ForEach(viewModel.usersNotFriends) { user in
                        HStack(spacing: 5) {
                            Text(user.firstName)
                            
                            Text(user.lastName)
                            
                            Spacer()
                            
                            if viewModel.requested(friendId: user.id) {
                                HStack {
                                    Text("Sent")
                                        
                                    Image(systemName: "paperplane.fill")
                                }
                                .padding(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(.black, lineWidth: 3)
                                )
                                .opacity(0.75)
                            } else {
                                Button {
                                    viewModel.sendFriendRequest(friendId: user.id)
                                } label: {
                                    Image(systemName: "plus.circle.fill")
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                        .foregroundStyle(.green)
                                }
                            }
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
            .navigationTitle("Add Friends")
        }
        .searchable(text: $search)
        .safeAreaInset(edge: .bottom) {
            ButtonComponent(title: "Done", image: nil, color: .red) {
                self.isAddingFriend = false
            }
            .padding()
        }
    }
}

struct AddFriendView_Previews: PreviewProvider {
    static let viewModel = AuthenticationViewModel()

    static var previews: some View {
        AddFriendView(isAddingFriend: .constant(true))
            .environmentObject(viewModel)
    }
}
