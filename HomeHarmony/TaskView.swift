//
//  TaskView.swift
//  HomeHarmony
//
//  Created by Daniel Madjar on 3/28/24.
//

import SwiftUI

struct TaskView: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    
    @State private var isCompactView: Bool = false
    
    @State private var search: String = ""
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 15) {
                    if viewModel.tasksLoading {
                        ForEach(0..<5) { _ in
                            ShimmerView()
                                .frame(height: 100)
                                .cornerRadius(10)
                        }
                    } else {
                        ForEach(taskResults) { task in
                            TaskCardComponent(isCompactView: isCompactView, taskItem: task)
                        }
                    }
                }
                .padding(.horizontal)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color("backgroundColor"))
            .overlay {
                if taskResults.isEmpty && !viewModel.tasksLoading {
                    EmptyListView(isFamily: false) {
                        if search.isEmpty {
                            Text("It looks like you have no tasks, try joining a family to get started!")
                        } else {
                            Text("No tasks with that name found!")
                        }
                    }
                }
            }
            .safeAreaInset(edge: .top) {
                NavBarComponent(
                    search: $search,
                    title: "Your Tasks") {
                        Menu {
                            Button("Compact View") {
                                self.isCompactView = true
                            }
                            
                            Button("Card View") {
                                self.isCompactView = false
                            }
                        } label: {
                            Image(systemName: "line.3.horizontal")
                                .font(.system(size: 28))
                                .bold()
                                .foregroundStyle(Color("textColor"))
                        }
                }
            }
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


struct TaskView_Previews: PreviewProvider {
    static let viewModel = AuthenticationViewModel()

    static var previews: some View {
        TaskView()
            .environmentObject(viewModel)
    }
}
