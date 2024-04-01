//
//  PopupView.swift
//  HomeHarmony
//
//  Created by Daniel Madjar on 4/1/24.
//

import SwiftUI

struct PopupView<Content: View>: View {
    @Environment(\.dismiss) private var dismiss
    
    let title: String
    
    @ViewBuilder let content: Content
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundStyle(.black.opacity(0.15))
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Text(title)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "x.circle.fill")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundStyle(.black)
                    }
                }
                
                content
            }
            .padding()
            .background(.white)
            .cornerRadius(10)
            .padding(.horizontal, 20)
        }
    }
}

struct PopupView_Previews: PreviewProvider {
    static var previews: some View {
        PopupView(title: "Title", content: {
            
        })
    }
}
