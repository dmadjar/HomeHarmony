//
//  NavBar.swift
//  Budget_MVVM
//
//  Created by Daniel Madjar on 1/22/24.
//

import SwiftUI

struct NavBarComponent<Content: View>: View {
    @Binding var search: String
    let title: String
    
    @ViewBuilder let content: Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 5) {
                Text(title)
                    .font(Font.custom("Sansita-ExtraBold", size: 36))
                
                Spacer()
                
                content
            }
            
            SearchComponent(search: $search)
        }
        .padding(.horizontal)
        .padding(.bottom, 10)
        .background(Color("backgroundColor"))
    }
}

#Preview {
    NavBarComponent(
        search: .constant(""),
        title: "Furniture",
        content: {}
    )
}
