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
                                HStack {
                                    Text(task.taskName)
                                        .font(.title3)
                                        .fontWeight(.bold)
                                    
                                    Spacer()
                                }
                                
                                Text(task.description)
                            }
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.black, lineWidth: 3)
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
