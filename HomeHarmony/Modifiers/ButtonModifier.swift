//
//  ButtonModifier.swift
//  HomeHarmony
//
//  Created by Daniel Madjar on 4/1/24.
//

import SwiftUI

struct ButtonModifier: ViewModifier {
    let bgColor: Color
    let textColor: Color
    
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity)
            .foregroundStyle(textColor)
            .padding()
            .background(bgColor)
            .cornerRadius(10)
    }
}
