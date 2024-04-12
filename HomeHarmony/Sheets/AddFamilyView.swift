//
//  AddFamilyView.swift
//  Home_Harmony
//
//  Created by Daniel Madjar on 3/18/24.
//

import SwiftUI

struct AddFamilyView: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @Binding var isAddingFamily: Bool
    @State private var familyName: String = ""
    @State private var members: Set<CustomUser> = []
    
    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            Text("Create Family")
                .font(.custom("Sansita-ExtraBold", size: 36))
            
            VStack(spacing: 10) {
                HStack {
                    Image(systemName: "person.2.fill")
                    
                    TextField("", text: $familyName,
                              prompt: Text("Family Name")
                        .font(.custom("Sansita-Regular", size: 20))
                        .foregroundStyle(Color("textColor").opacity(0.5))
                    )
                }
                
                RoundedRectangle(cornerRadius: 10)
                    .frame(height: 2)
            }
            .foregroundStyle(Color("textColor").opacity(0.5))
            
            if !viewModel.friends.isEmpty {
                HStack {
                    Text("Add Members")
                        .font(.custom("Sansita-ExtraBold", size: 28))
                    
                    Spacer()
                }
                
                ScrollView {
                    ForEach(viewModel.friends, id: \.customUser.id) { friend in
                        HStack {
                            Text("\(friend.customUser.firstName) \(friend.customUser.lastName)")
                            
                            Spacer()
                            
                            Button {
                                if members.contains(friend.customUser) {
                                    members.remove(friend.customUser)
                                } else {
                                    members.insert(friend.customUser)
                                }
                            } label: {
                                if members.contains(friend.customUser) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundStyle(Color("greenColor"))
                                } else {
                                    Image(systemName: "circle")
                                        .foregroundStyle(Color("textColor").opacity(0.5))
                                }
                            }
                        }
                        .foregroundStyle(Color("blackColor"))
                        .font(.custom("Sansita-ExtraBold", size: 20))
                        .padding(15)
                        .background(Color("redColor"))
                        .cornerRadius(10)
                        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
                    }
                }
                .frame(height: 150)
                .cornerRadius(10)
            }
            
            ButtonComponent(title: "Done", image: nil, backgroundColor: Color("blueColor"), textColor: Color("textColor")) {
                Task {
                    if let customUser = viewModel.customUser {
                        members.insert(customUser)
                        await viewModel.createFamily(familyName: familyName, members: members)
                        self.isAddingFamily = false
                    }
                }
            }
        }
        .padding()
    }
}

struct AddFamilyView_Previews: PreviewProvider {
    static let viewModel = AuthenticationViewModel()

    static var previews: some View {
        AddFamilyView(isAddingFamily: .constant(true))
            .environmentObject(viewModel)
    }
}
