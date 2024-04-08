//
//  ProgressComponent.swift
//  HomeHarmony
//
//  Created by Daniel Madjar on 4/8/24.
//

import SwiftUI

struct ProgressComponent: View {
    let progress: Int
    
    var body: some View {
        HStack(spacing: 5) {
            Image(systemName: images.0)
                .foregroundStyle(
                    progress == 0
                        ? Color("lightPink")
                    : .white.opacity(0.3)
                )
                
            Image(systemName: images.1)
                .foregroundStyle(
                    progress == 1
                        ? Color("lightYellow")
                    : .white.opacity(0.3)
                )
            
            Image(systemName: images.2)
                .foregroundStyle(
                    progress == 2
                        ? Color("lightGreen")
                    : .white.opacity(0.3)
                )
        }
        .font(.system(size: 24))
        .background(Color("slate").opacity(0.2))
        .cornerRadius(50)
        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
    }
    
    var images: (String, String, String) {
        switch progress {
        case 0:
            return ("minus.circle.fill", "ellipsis.circle", "checkmark.circle")
        case 1:
            return ("minus.circle", "ellipsis.circle.fill", "checkmark.circle")
        case 2:
            return ("minus.circle", "ellipsis.circle", "checkmark.circle.fill")
        default:
            return ("", "", "")
        }
    }
}

#Preview {
    ProgressComponent(progress: 0)
}
