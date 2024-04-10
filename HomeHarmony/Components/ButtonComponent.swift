//
//  ButtonComponent.swift
//  HomeHarmony
//
//  Created by Daniel Madjar on 3/28/24.
//

import SwiftUI

struct ButtonComponentStyle: ButtonStyle {
    let image: String?
    let backgroundColor: Color
    let textColor: Color
    
    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: 5) {
            if let img = image {
                Image(systemName: img)
            }
            
            configuration.label
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(configuration.isPressed ? backgroundColor.opacity(0.75) : backgroundColor)
        .cornerRadius(10)
        .foregroundStyle(textColor)
        .font(.custom("Sansita-Bold", size: 20))
        .scaleEffect(configuration.isPressed ? 0.95 : 1)
        .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct ButtonComponent: View {
    let title: String
    let image: String?
    let backgroundColor: Color
    let textColor: Color
    let action: () -> Void
    
    var body: some View {
        Button(title) {
            action()
        }
        .buttonStyle(ButtonComponentStyle(image: image, backgroundColor: backgroundColor, textColor: textColor))
        //.shadow(color: .black.opacity(0.10), radius: 10, x: 0, y: 5)
    }
}

#Preview {
    ButtonComponent(title: "Test Button", image: nil, backgroundColor: .white, textColor: .black, action: {})
}
