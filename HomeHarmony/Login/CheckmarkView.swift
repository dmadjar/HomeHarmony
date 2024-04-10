//
//  CheckmarkView.swift
//  HomeHarmony
//
//  Created by Daniel Madjar on 4/8/24.
//

import SwiftUI

struct CheckmarkView: View {
    let isReversed: Bool
    
    let opacities: [CGFloat] = [
        0.30, 0.25, 0.20, 0.15, 0.1, 0.05
    ]
    
    var body: some View {
        VStack(spacing: 7) {
            ForEach(0..<6) { index in
                HStack(spacing: 20) {
                    ForEach(0..<9) { _ in
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 28))
                            .foregroundStyle(Color("blueColor"))
                    }
                }
                .offset(x: isEven(index: index) ? 25 : 0)
                .opacity(isReversed ? opacities[5 - index] : opacities[index])
            }
        }
    }
    
    private func isEven(index: Int) -> Bool {
        return index % 2 == 0
    }
}

#Preview {
    CheckmarkView(isReversed: false)
}
