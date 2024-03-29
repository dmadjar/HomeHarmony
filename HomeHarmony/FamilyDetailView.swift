//
//  TaskView.swift
//  Home_Harmony
//
//  Created by Daniel Madjar on 3/18/24.
//

import SwiftUI


struct ProgressTag: View {
    let name: String
    let progress: Int
    
    var body: some View {
        Text(name)
            .fontWeight(.bold)
            .foregroundStyle(.white)
            .padding(10)
            .background(progressColor())
            .cornerRadius(5)
    }
    
    private func progressColor() -> Color {
        switch progress {
        case 1:
            return .red
        case 2:
            return .yellow
        case 3:
            return .green
        default:
            return .black
        }
    }
}

struct FamilyDetailView: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    
    @State private var isAddingTask: Bool = false
    @State private var search: String = ""
    
    let extractedFamily: ExtractedFamily
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 15) {
                    Text("Tasks")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    ForEach(taskResults, id: \.task.id) { extendedTask in
                        VStack(alignment: .leading) {
                            HStack(alignment: .top) {
                                Text(extendedTask.task.taskName)
                                    .font(.title3)
                                    .fontWeight(.bold)
                                
                                Spacer()
                                
                                ProgressTag(
                                    name: extendedTask.assigneeFirstName,
                                    progress: extendedTask.task.progress
                                )
                            }
                            
                            Text(extendedTask.task.description)
                        }
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.black, lineWidth: 3)
                        )
                    }
                    
                    Text("Members")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    ForEach(extractedFamily.members) { member in
                        HStack(spacing: 5) {
                            Text(member.firstName)
                            
                            Text(member.lastName)
                            
                            Spacer()
                            
                            if (member.id == extractedFamily.creator.id) {
                                Text("Creator")
                                    .foregroundStyle(.red)
                            }
                        }
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.black, lineWidth: 3)
                        )
                    }
                }
                .padding(.horizontal)
            }
            .navigationTitle(extractedFamily.familyName)
            .searchable(text: $search)
            .safeAreaInset(edge: .bottom) {
                ButtonComponent(title: "Add Task", image: nil, color: .red) {
                    self.isAddingTask = true
                }
                .padding()
            }
            .sheet(isPresented: $isAddingTask, content: {
                AddTaskView(isAddingTask: $isAddingTask, family: extractedFamily)
            })
        }
        .onAppear {
            Task {
                if let familyID = extractedFamily.id {
                    await viewModel.getTasks(familyID: familyID)
                }
            }
        }
    }
    
    private var taskResults: [ExtendedTaskItem] {
        if search.isEmpty {
            return viewModel.tasks
        } else {
            return viewModel.tasks.filter { $0.task.taskName.contains(search) }
        }
    }
}

//#Preview {
//    TaskView()
//}
