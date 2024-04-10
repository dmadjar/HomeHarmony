//
//  ProgressComponent.swift
//  HomeHarmony
//
//  Created by Daniel Madjar on 4/8/24.
//

import SwiftUI

struct ProgressCompactComponent: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    let taskItem: TaskItem
    
    var body: some View {
        Menu {
            Button("Not Started") {
                updateProgress(progress: 0)
            }
            
            Button("In Progress") {
                updateProgress(progress: 1)
            }
            
            Button("Complete") {
                updateProgress(progress: 2)
            }
        } label: {
             Image(systemName: image)
                .foregroundStyle(Color("blackColor").opacity(0.5))
                .font(.system(size: 24))
        }
    }
    
    var image: String {
        switch taskItem.progress {
        case 0:
            return "minus.circle.fill"
        case 1:
            return "ellipsis.circle.fill"
        case 2:
            return "checkmark.circle.fill"
        default:
            return ""
        }
    }
                
    private func updateProgress(progress: Int) {
        if let id = taskItem.id {
            Task {
                await viewModel.updateTaskProgress(
                    taskID: id,
                    familyID: taskItem.familyID,
                    progress: progress
                )
            }
        }
    }
}

struct ProgressCompactComponent_Previews: PreviewProvider {
    static let viewModel = AuthenticationViewModel()

    static let taskItem = TaskItem(
        taskName: "Task Name",
        description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus ut rhoncus dui, at imperdiet diam",
        assigneeID: "",
        finishBy: Date.now,
        familyID: "",
        progress: 0, 
        taskColor: 0
    )
    
    static var previews: some View {
        ProgressCompactComponent(taskItem: taskItem)
            .environmentObject(viewModel)
    }
}

struct ProgressComponent: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    let taskItem: TaskItem
    
    var body: some View {
        HStack(spacing: 5) {
            Button {
                updateProgress(progress: 0)
            } label: {
                Image(systemName: images.0)
                    .foregroundStyle(
                        taskItem.progress == 0
                            ? Color("redColor")
                        : .white.opacity(0.3)
                    )
            }
            
            Button {
                updateProgress(progress: 1)
            } label: {
                Image(systemName: images.1)
                    .foregroundStyle(
                        taskItem.progress == 1
                            ? Color("yellowColor")
                        : .white.opacity(0.3)
                    )
            }

            Button {
                updateProgress(progress: 2)
            } label: {
                Image(systemName: images.2)
                    .foregroundStyle(
                        taskItem.progress == 2
                            ? Color("greenColor")
                        : .white.opacity(0.3)
                    )
            }
        }
        .font(.system(size: 24))
        .background(Color("blackColor").opacity(0.5))
        .cornerRadius(50)
        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
    }
    
    var images: (String, String, String) {
        switch taskItem.progress {
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
    
    private func updateProgress(progress: Int) {
        if let id = taskItem.id {
            Task {
                await viewModel.updateTaskProgress(
                    taskID: id,
                    familyID: taskItem.familyID,
                    progress: progress
                )
            }
        }
    }
}

struct ProgressComponent_Previews: PreviewProvider {
    static let viewModel = AuthenticationViewModel()

    static let taskItem = TaskItem(
        taskName: "Task Name",
        description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus ut rhoncus dui, at imperdiet diam",
        assigneeID: "",
        finishBy: Date.now,
        familyID: "",
        progress: 0,
        taskColor: 0
    )
    
    static var previews: some View {
        ProgressComponent(taskItem: taskItem)
            .environmentObject(viewModel)
    }
}
