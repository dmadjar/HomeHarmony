//
//  TaskCardView.swift
//  HomeHarmony
//
//  Created by Daniel Madjar on 4/8/24.
//

import SwiftUI

struct TaskCardComponent: View {
    
    let isCompactView: Bool
    let taskItem: TaskItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Text(taskItem.taskName)
                    .font(.custom("Sansita-ExtraBold", size: 20))
                
                Spacer()
                
                HStack {
                    if isCompactView {
                        ProgressCompactComponent(taskItem: taskItem)
                    }
                    
                    Text(getDayOfWeek(finishBy: taskItem.finishBy))
                }
                .font(.custom("Sansita-Bold", size: 15))
                .padding(.vertical, 5)
                .padding(.horizontal, 10)
                .background(.black.opacity(0.10))
                .cornerRadius(5)
            }
            
            if !isCompactView {
                Text(taskItem.description)
                    .font(.custom("Sansita-Bold", size: 15))
                
                HStack {
                    Spacer()
                    
                    ProgressComponent(taskItem: taskItem)
                }
            }
        }
        .padding(15)
        .background(Color("red"))
        .foregroundStyle(Color("black"))
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
        .transition(.move(edge: .bottom))
        .animation(.easeInOut, value: isCompactView)
    }
    
    private func getDayOfWeek(finishBy: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let weekday = dateFormatter.string(from: finishBy)
        return weekday
    }
}

struct TaskCardComponent_Previews: PreviewProvider {
    static let viewModel = AuthenticationViewModel()

    static let taskItem = TaskItem(
        taskName: "Task Name",
        description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus ut rhoncus dui, at imperdiet diam",
        assigneeID: "",
        finishBy: Date.now,
        familyID: "",
        progress: 0
    )
    
    static var previews: some View {
        TaskCardComponent(isCompactView: false, taskItem: taskItem)
            .environmentObject(viewModel)
    }
}

