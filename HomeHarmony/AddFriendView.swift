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
        VStack(alignment: .leading) {
            Text("Add Friends")
                .font(.custom("Sansita-ExtraBold", size: 36))
                .foregroundStyle(Color("textColor"))
            
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
                                .background(Color("textColor"))
                                .foregroundStyle(Color("defaultColor"))
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
                        .padding(15)
                        .font(.custom("Sansita-Bold", size: 17))
                        .background(Color("secondaryColor"))
                        .foregroundStyle(Color("textColor"))
                        .cornerRadius(10)
                        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
                    }
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("backgroundColor"))
        .safeAreaInset(edge: .bottom) {
            ButtonComponent(title: "Done", image: nil, backgroundColor: Color("textColor"), textColor: Color("defaultColor")) {
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
