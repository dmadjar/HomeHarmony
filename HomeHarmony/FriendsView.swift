//
//  FriendsView.swift
//  Home_Harmony
//
//  Created by Daniel Madjar on 3/18/24.
//

import SwiftUI

struct FriendsView: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            if viewModel.friendsLoading {
                ForEach(0..<5) { _ in
                    ShimmerView()
                        .frame(height: 100)
                        .cornerRadius(10)
                }
            } else {
                ForEach(viewModel.friends) { friend in
                    HStack(spacing: 5) {
                        
                        
                        Text(friend.firstName)
                        
                        Text(friend.lastName)
                        
                        Spacer()
                    }
                    .padding(15)
                    .font(.custom("Sansita-Bold", size: 17))
                    .background(Color("secondaryColor"))
                    .foregroundStyle(Color("textColor"))
                    .cornerRadius(10)
                }
                
                if !viewModel.friendRequests.isEmpty {
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
                                    .foregroundStyle(Color("redColor"))
                            }
                            
                            Button {
                                Task {
                                    await viewModel.acceptRequest(requestId: request.id)
                                }
                            } label: {
                                Image(systemName: "checkmark.circle.fill")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .foregroundStyle(Color("greenColor"))
                            }
                        }
                        .padding(15)
                        .font(.custom("Sansita-Bold", size: 17))
                        .background(Color("secondaryColor"))
                        .foregroundStyle(Color("textColor"))
                        .cornerRadius(10)
                    }
                }
            }
        }
    }
}

struct FriendsView_Previews: PreviewProvider {
    static let viewModel = AuthenticationViewModel()
    
    static var previews: some View {
        FriendsView()
            .environmentObject(viewModel)
    }
}
