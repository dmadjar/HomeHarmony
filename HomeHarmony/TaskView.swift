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
                VStack(alignment: .leading, spacing: 20) {
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
                                    .foregroundStyle(Color("slate"))
                            }
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
