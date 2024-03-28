//
//  ButtonComponent.swift
//  HomeHarmony
//
//  Created by Daniel Madjar on 3/28/24.
//

import SwiftUI

struct ButtonComponentStyle: ButtonStyle {
    let image: String?
    let color: Color
    
    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: 5) {
            if let img = image {
                Image(systemName: img)
            }
            
            configuration.label
                .foregroundStyle(.white)
                .fontWeight(.semibold)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(configuration.isPressed ? color.opacity(0.75) : color)
        .cornerRadius(10)
        .font(.system(size: 17).weight(.semibold))
        .scaleEffect(configuration.isPressed ? 0.95 : 1)
        .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct ButtonComponent: View {
    let title: String
    let image: String?
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(title) {
            action()
        }
        .buttonStyle(ButtonComponentStyle(image: image, color: color))
        .shadow(color: .black.opacity(0.10), radius: 5)
    }
}

#Preview {
    ButtonComponent(title: "Test Button", image: nil, color: .red, action: {})
}
