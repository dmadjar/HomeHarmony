//
//  FamilyComponent.swift
//  HomeHarmony
//
//  Created by Daniel Madjar on 4/8/24.
//

import SwiftUI

struct FamilyComponent: View {
    let extendedFamily: ExtendedFamily
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 15) {
                HStack {
                    Text(extendedFamily.familyName)
                        .font(.custom("Sansita-ExtraBold", size: 20))
                    
                    Spacer()
                  
                        
                    Text(extendedFamily.creator.firstName)
                        .font(.custom("Sansita-Bold", size: 15))
                        .padding(.vertical, 5)
                        .padding(.horizontal, 10)
                        .background(.black.opacity(0.10))
                        .cornerRadius(5)
                }
                
                Text(numTasks(tasks: extendedFamily.tasks))
                    .font(.custom("Sansita-Bold", size: 15))
            }
            
            
            Image(systemName: "chevron.right")
                .font(.system(size: 20))
                .foregroundStyle(.black.opacity(0.1))
                .bold()
        }
        .padding(15)
        .background(Color("lightPink"))
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
    }
    
    private func numTasks(tasks: [ExtendedTaskItem]) -> String {
        if (tasks.count == 0) {
            return "No tasks to complete!"
        } else if (tasks.count == 1) {
            return "1 task to complete."
        } else {
            return "\(tasks.count) tasks to complete."
        }
    }
}

//#Preview {
//    FamilyComponent()
//}
