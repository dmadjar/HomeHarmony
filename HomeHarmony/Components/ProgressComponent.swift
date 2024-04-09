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
                .foregroundStyle(color)
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
    
    var color: Color {
        switch taskItem.progress {
        case 0:
            return Color("lightPink")
        case 1:
            return Color("lightYellow")
        case 2:
            return Color("lightGreen")
        default:
            return Color("slate")
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
                            ? Color("lightPink")
                        : .white.opacity(0.3)
                    )
            }
            
            Button {
                updateProgress(progress: 1)
            } label: {
                Image(systemName: images.1)
                    .foregroundStyle(
                        taskItem.progress == 1
                            ? Color("lightYellow")
                        : .white.opacity(0.3)
                    )
            }

            Button {
                updateProgress(progress: 2)
            } label: {
                Image(systemName: images.2)
                    .foregroundStyle(
                        taskItem.progress == 2
                            ? Color("lightGreen")
                        : .white.opacity(0.3)
                    )
            }
        }
        .font(.system(size: 24))
        .background(Color("slate").opacity(0.2))
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

//#Preview {
//    ProgressComponent()
//}
