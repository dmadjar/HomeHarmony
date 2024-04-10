//
//  FamilyTaskComponent.swift
//  HomeHarmony
//
//  Created by Daniel Madjar on 4/8/24.
//

import SwiftUI

struct FamilyTaskComponent: View {
    let extendedTask: ExtendedTaskItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Text(extendedTask.task.taskName)
                    .font(.custom("Sansita-ExtraBold", size: 20))
                
                Spacer()
                
                HStack {
                    ProgressCompactComponent(taskItem: extendedTask.task)
                        .disabled(true)
            
                    Text(getDayOfWeek(finishBy: extendedTask.task.finishBy))
                }
                .font(.custom("Sansita-Bold", size: 15))
                .padding(.vertical, 5)
                .padding(.horizontal, 10)
                .background(Color("blackColor").opacity(0.15))
                .cornerRadius(5)
            }
            
            Text(extendedTask.task.description)
                .font(.custom("Sansita-Bold", size: 15))
            
            Text("Assigned to: \(extendedTask.assigneeFirstName)")
                .font(.custom("Sansita-Bold", size: 15))
        }
        .padding(15)
        .background(colorHelper(taskColor: extendedTask.task.taskColor))
        .cornerRadius(10)
        .foregroundStyle(Color("blackColor"))
        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
    }
    
    private func getDayOfWeek(finishBy: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let weekday = dateFormatter.string(from: finishBy)
        return weekday
    }
}

struct FamilyTaskComponent_Previews: PreviewProvider {
    static let viewModel = AuthenticationViewModel()

    static let extendedTaskItem = ExtendedTaskItem(
        task: TaskItem(
            taskName: "Task Name",
            description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus ut rhoncus dui, at imperdiet diam",
            assigneeID: "",
            finishBy: Date.now,
            familyID: "",
            progress: 0,
            taskColor: 0
        ),
        assigneeFirstName: "Daniel"
    )
    
    static var previews: some View {
        FamilyTaskComponent(extendedTask: extendedTaskItem)
            .environmentObject(viewModel)
    }
}
