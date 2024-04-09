//
//  MemberComponent.swift
//  HomeHarmony
//
//  Created by Daniel Madjar on 4/9/24.
//

import SwiftUI

struct MemberComponent: View {
    let member: CustomUser
    let creatorId: String?
    
    var body: some View {
        HStack {
            Text("\(member.firstName) \(member.lastName)")
                .font(.custom("Sansita-ExtraBold", size: 20))
            
            Spacer()
            
            if member.id == creatorId {
                Text("Creator")
                    .font(.custom("Sansita-Bold", size: 15))
                    .padding(.vertical, 5)
                    .padding(.horizontal, 10)
                    .background(.black.opacity(0.10))
                    .cornerRadius(5)
            }
        }
        .padding(15)
        .background(
            LinearGradient(
                colors: [Color("lightOrange"), Color("darkOrange")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
    }
}

//#Preview {
//    MemberComponent()
//}
