//
//  EmptyListView.swift
//  HomeHarmony
//
//  Created by Daniel Madjar on 4/12/24.
//

import SwiftUI

struct EmptyListView<Content: View>: View {
    let isFamily: Bool
    
    @ViewBuilder var content: Content
    
    var body: some View {
        VStack(spacing: 30) {
            if isFamily {
                Image(systemName: "person.3.fill")
                    .resizable()
                    .scaledToFit()
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(
                        LinearGradient(colors: [Color("blueColor"), Color("textColor")], startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
            } else {
                Image(systemName: "checkmark.seal.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .foregroundStyle(
                        LinearGradient(colors: [Color("blueColor"), Color("textColor")], startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
            }
            
            content
                .multilineTextAlignment(.center)
                .font(.custom("Sansita-Bold", size: 17))
                .foregroundStyle(Color("textColor").opacity(0.5))
        }
        .padding(50)
    }
}

#Preview {
    EmptyListView(isFamily: false, content: {
        Text("It looks like you have no tasks, try joining a family to get started!")
    })
}
