//
//  TextFieldComponent.swift
//  HomeHarmony
//
//  Created by Daniel Madjar on 4/11/24.
//

import SwiftUI

struct TextFieldComponent: View {
    @Binding var text: String
    let title: String
    let image: String
    let isSecure: Bool
    
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Image(systemName: image)
                    
                if isSecure {
                    SecureField("", text: $text, prompt: Text(title)
                        .font(.custom("Sansita-Regular", size: 20))
                        .foregroundStyle(Color("textColor").opacity(0.5)))
                } else {
                    TextField("", text: $text, prompt: Text(title)
                        .font(.custom("Sansita-Regular", size: 20))
                        .foregroundStyle(Color("textColor").opacity(0.5)))
                }
            }
            
            RoundedRectangle(cornerRadius: 10)
                .frame(height: 2)
        }
        .foregroundStyle(Color("textColor").opacity(0.5))
    }
}
