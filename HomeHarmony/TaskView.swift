//
//  TaskView.swift
//  HomeHarmony
//
//  Created by Daniel Madjar on 3/28/24.
//

import SwiftUI

struct TaskView: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    
    @State private var search: String = ""
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    if viewModel.tasksLoading {
                        ForEach(0..<5) { _ in
                            ShimmerView()
                                .frame(height: 100)
                                .cornerRadius(10)
                        }
                    } else {
                        ForEach(taskResults) { task in
                            VStack(alignment: .leading, spacing: 10) {
                                HStack(alignment: .top) {
                                    Text(task.taskName)
                                        .font(.title2)
                                        .fontWeight(.bold)
                                    
                                    Spacer()
                                    
                                    IndividualProgressView(progress: task.progress)
                                }
                                
                                Text(task.description)
                                    .fontWeight(.medium)
                                
                                Text(getDayOfWeek(finishBy: task.finishBy))
                                    .fontWeight(.medium)
                                    .foregroundStyle(.black)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 5)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(.black.opacity(0.15), lineWidth: 2)
                                    )
                                
                                if task.progress != 3 {
                                    ProgressIndicatorView(taskCurrentProgress: task.progress, taskID: task.id)
                                }
                            }
                            .padding(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.black.opacity(0.15), lineWidth: 2)
                            )
                        }
                    }
                }
                .padding(.horizontal)
            }
            .navigationTitle("Your Tasks")
            .searchable(text: $search)
        }
    }
    
    private var taskResults: [TaskItem] {
        if search.isEmpty {
            return viewModel.yourTasks
        } else {
            return viewModel.yourTasks.filter { $0.taskName.contains(search) }
        }
    }
    
    private func getDayOfWeek(finishBy: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let weekday = dateFormatter.string(from: finishBy)
        return weekday
    }
}

#Preview {
    TaskView()
}
