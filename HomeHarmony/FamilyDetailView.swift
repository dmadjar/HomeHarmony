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
            .modifier(ProgressModifier(bgColor: progressColor(progress: progress)))
    }
}

func progressColor(progress: Int) -> Color {
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

struct FamilyDetailView: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    
    @State private var isAddingTask: Bool = false
    @State private var search: String = ""
    @State private var isPopupOpen: Bool = false
    @State private var dateSelected: Date? = nil
    
    let extendedFamily: ExtendedFamily
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                Text("Tasks")
                    .font(.title)
                    .fontWeight(.bold)
                
                ForEach(taskResults, id: \.task.id) { extendedTask in
                    VStack(alignment: .leading, spacing: 10) {
                        HStack(alignment: .top) {
                            Text(extendedTask.task.taskName)
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            Spacer()
                            
                            IndividualProgressView(progress: extendedTask.task.progress)
                        }
                        
                        Text(extendedTask.task.description)
                            .fontWeight(.medium)
                        
                        HStack {
                            Text(getDayOfWeek(finishBy: extendedTask.task.finishBy))
                                .fontWeight(.medium)
                                .foregroundStyle(.black)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(.black.opacity(0.15), lineWidth: 2)
                                )
                            
                            Spacer()
                            
                            Text("Assigned to: \(extendedTask.assigneeFirstName)")
                        }
                    }
                    .padding(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.black.opacity(0.15), lineWidth: 2)
                    )
                }
                
                CalendarView(isPopupOpen: $isPopupOpen, dateSelected: $dateSelected, dayToTask: dayToTask)
                
                Text("Members")
                    .font(.title)
                    .fontWeight(.bold)
                
                ForEach(extendedFamily.members) { member in
                    HStack(spacing: 5) {
                        Text(member.firstName)
                        
                        Text(member.lastName)
                        
                        Spacer()
                        
                        if (member.id == extendedFamily.creator.id) {
                            ProgressTag(
                                name: "Creator",
                                progress: 1
                            )
                        }
                    }
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.black.opacity(0.15), lineWidth: 2)
                    )
                }
            }
            .padding(.horizontal)
        }
        .navigationTitle(extendedFamily.familyName)
        .searchable(text: $search)
        .safeAreaInset(edge: .bottom) {
            ZStack {
                if let dateSelected = dateSelected {
                    if isPopupOpen {
                        PopupView(title: "Task Details", isPopupOpen: $isPopupOpen) {
                            CalendarDataView(day: dateSelected, tasks: extendedFamily.tasks)
                        }
                    }
                }
                
                ButtonComponent(title: "Add Task", image: nil, color: .red) {
                    self.isAddingTask = true
                }
                .padding()
            }
        }
        .sheet(isPresented: $isAddingTask, content: {
            AddTaskView(isAddingTask: $isAddingTask, family: extendedFamily)
        })
    }
    
    private var taskResults: [ExtendedTaskItem] {
        if search.isEmpty {
            return extendedFamily.tasks
        } else {
            return extendedFamily.tasks.filter { $0.task.taskName.contains(search) }
        }
    }
    
    private func getDayOfWeek(finishBy: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let weekday = dateFormatter.string(from: finishBy)
        return weekday
    }
    
    var dayToTask: [DateComponents : [Int]] {
        var dictionary = [DateComponents : [Int]]()
        for taskItem in extendedFamily.tasks {
            let components = Calendar.current.dateComponents([.year, .month, .day], from: taskItem.task.finishBy)
            if dictionary[components] != nil {
                dictionary[components]!.append(taskItem.task.progress)
            } else {
                dictionary[components] = [taskItem.task.progress]
            }
            
        }
        return dictionary
    }
}

struct CalendarDataView: View {
    let day: Date
    
    let tasks: [ExtendedTaskItem]
    
    var body: some View {
        ScrollView {
            ForEach(selectedTasks, id: \.task.id) { task in
                Text(task.task.taskName)
            }
        }
        .frame(height: 250)
    }
    
    var selectedTasks: [ExtendedTaskItem] {
        return tasks.filter {
            return $0.task.finishBy.startOfDay == day
        }
    }
}
