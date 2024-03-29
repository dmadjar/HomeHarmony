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
                VStack(alignment: .leading, spacing: 15) {
                    if viewModel.isLoading() {
                        ForEach(0..<4) { _ in
                            ShimmerView()
                                .frame(height: 100)
                                .cornerRadius(10)
                        }
                    } else {
                        ForEach(taskResults) { task in
                            VStack(alignment: .leading) {
                                HStack(alignment: .top) {
                                    Text(task.taskName)
                                        .font(.title2)
                                        .fontWeight(.bold)
                                    
                                    Spacer()
                                    
                                    IndividualProgressView(progress: task.progress)
                                }
                                
                                Text(task.description)
                                    .fontWeight(.medium)
                                
                                ProgressIndicatorView(taskCurrentProgress: task.progress, taskID: task.id)
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
    
    var taskResults: [TaskItem] {
        if search.isEmpty {
            return viewModel.yourTasks
        } else {
            return viewModel.yourTasks.filter { $0.taskName.contains(search) }
        }
    }
}

#Preview {
    TaskView()
}
