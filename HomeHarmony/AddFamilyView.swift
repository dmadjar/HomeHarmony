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
        VStack(spacing: 15) {
            Text("Create Family")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            TextField("Family Name", text: $familyName)
                .modifier(TextModifier(cornerRadius: 10, color: .black.opacity(0.75)))
            
            HStack {
                Menu("Add Members") {
                    ForEach(viewModel.friends) { friend in
                        Button {
                            members.insert(friend)
                        } label: {
                            Text("\(friend.firstName) \(friend.lastName)")
                                .font(.title2)
                                .fontWeight(.bold)
                        }
                    }
                }
                .buttonStyle(ButtonComponentStyle(image: nil, color: .red))
            }
            
            ScrollView(.horizontal) {
                HStack {
                    ForEach(Array(members)) { member in
                        Button {
                            self.members.remove(member)
                        } label: {
                            HStack {
                                Text(member.firstName)
                                
                                Image(systemName: "xmark.circle.fill")
                            }
                            .foregroundStyle(.white)
                            .padding()
                            .background(.red)
                            .cornerRadius(10)
                        }
                    }
                }
            }
            
            ButtonComponent(title: "Done", image: nil, color: .red) {
                Task {
                    await viewModel.createFamily(familyName: familyName, members: members)
                    self.isAddingFamily = false
                }
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    AddFamilyView(isAddingFamily: .constant(true))
}
