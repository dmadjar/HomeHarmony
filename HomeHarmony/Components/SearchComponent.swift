//
//  SearchBar.swift
//  Budget_MVVM
//
//  Created by Daniel Madjar on 1/22/24.
//

import SwiftUI

struct SearchComponent: View {
    @Binding var search: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                
            TextField("", text: $search, 
                      prompt: Text("Search")
                .font(.custom("Sansita-Regular", size: 20))
                .foregroundStyle(Color("slate").opacity(0.5))
            )
            
            Spacer()
            
            if !search.isEmpty {
                Button {
                    withAnimation {
                        self.search = ""
                    }
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .renderingMode(.template)
                }
            }
        }
        .padding(5)
        .font(.custom("Sansita-Regular", size: 20))
        .foregroundStyle(Color("slate").opacity(0.5))
        .background(Color("lightGray"))
        .cornerRadius(10)
    }
}

#Preview {
    SearchComponent(search: .constant(""))
}
