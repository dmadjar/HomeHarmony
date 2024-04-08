//
//  TaskCardView.swift
//  HomeHarmony
//
//  Created by Daniel Madjar on 4/8/24.
//

import SwiftUI

struct TaskCardComponent: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Text("Task Name")
                    .font(.custom("Sansita-ExtraBold", size: 20))
                
                Spacer()
                
                Text("Monday")
                    .font(.custom("Sansita-Bold", size: 15))
                    .padding(.vertical, 5)
                    .padding(.horizontal, 10)
                    .background(.black.opacity(0.10))
                    .cornerRadius(5)
            }
            
            Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus ut rhoncus dui, at imperdiet diam")
                .font(.custom("Sansita-Bold", size: 15))
            
            HStack {
                Spacer()
                
                ProgressComponent(progress: 0)
            }
        }
        .padding(15)
        .background(Color("lightGreen"))
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
    }
}

#Preview {
    TaskCardComponent()
}
