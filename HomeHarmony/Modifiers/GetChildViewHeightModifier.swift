//
//  Modifiers.swift
//  Budget
//
//  Created by Daniel Madjar on 12/31/23.
//

import SwiftUI

struct GetChildViewHeightModifier: ViewModifier {
    @Binding var size: CGFloat
    
    func body(content: Content) -> some View {
        content
            .overlay {
                GeometryReader { geo in
                    Color.clear
                        .preference(key: SizePreferenceKey.self, value: geo.size.height)
            }
            .onPreferenceChange(SizePreferenceKey.self) { newSize in
                size = newSize
            }
            .presentationDetents([.height(size)])
        }
    }
}

struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
