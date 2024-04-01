//
//  TextModifier.swift
//  HomeHarmony
//
//  Created by Daniel Madjar on 4/1/24.
//

import SwiftUI

struct TextModifier: ViewModifier {
    let cornerRadius: CGFloat
    let color: Color
    
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity)
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(color, lineWidth: 2)
            )
    }
}
