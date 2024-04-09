//
//  TaskView.swift
//  Home_Harmony
//
//  Created by Daniel Madjar on 3/18/24.
//

import SwiftUI


//struct ProgressTag: View {
//    let name: String
//    let progress: Int
//    
//    var body: some View {
//        Text(name)
//            .modifier(ProgressModifier(bgColor: progressColor(progress: progress)))
//    }
//}

func progressColor(progress: Int) -> LinearGradient {
    switch progress {
    case 0:
        return LinearGradient(
            colors: [Color("lightPink"), Color("darkPink")],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    case 1:
        return LinearGradient(
            colors: [Color("lightOrange"), Color("darkOrange")],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    case 2:
        return LinearGradient(
            colors: [Color("lightGreen"), Color("darkGreen")],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    default:
        return LinearGradient(
            colors: [.black],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

enum ActiveSheet: String, Identifiable {
    case addTask, showCalendarDetail
    var id: String {
        return self.rawValue
    }
}

struct FamilyDetailView: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    
    @State private var size: CGFloat = .zero
    
    @State private var search: String = ""
    @State private var dateSelected: Date? = nil
    @State private var sheetOpen: Bool = false
    @State private var activeSheet: ActiveSheet? = nil
    
    let extendedFamily: ExtendedFamily
    
    init(extendedFamily: ExtendedFamily) {
        self.extendedFamily = extendedFamily
        
        let attributes = [
            NSAttributedString.Key.font:
                UIFont(name: "Sansita-Regular", size: 17) as Any
        ]
        
        let navBarAppearance = UINavigationBarAppearance()
        
        let backAppearance = UIBarButtonItemAppearance()
        backAppearance.normal.titleTextAttributes = attributes
        backAppearance.highlighted.titleTextAttributes = attributes
        
        navBarAppearance.shadowImage = nil
        navBarAppearance.shadowColor = .none
        navBarAppearance.backgroundColor = .white
        navBarAppearance.buttonAppearance = backAppearance
        
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
        UINavigationBar.appearance().standardAppearance = navBarAppearance
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 30) {
                if !isEmpty() {
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Tasks")
                            .font(.custom("Sansita-ExtraBold", size: 32))
                                  
                        ForEach(taskResults, id: \.task.id) { extendedTask in
                            FamilyTaskComponent(extendedTask: extendedTask)
                        }
                    }
                }
                
                CalendarView(sheetOpen: $sheetOpen, showCalendarDetail: $activeSheet, dateSelected: $dateSelected, dayToTask: dayToTask)
                
                VStack(alignment: .leading, spacing: 15) {
                    Text("Members")
                        .font(.custom("Sansita-ExtraBold", size: 32))
                    
                    ForEach(extendedFamily.members) { member in
                        MemberComponent(
                            member: member,
                            creatorId: extendedFamily.creator.id
                        )
                    }
                }
            }
            .padding(.horizontal)
        }
        .safeAreaInset(edge: .top) {
            NavBarComponent(
                search: $search,
                title: extendedFamily.familyName,
                content: {}
            )
        }
        .safeAreaInset(edge: .bottom) {
            ButtonComponent(title: "Add Task", image: "plus") {
                self.activeSheet = .addTask
                self.sheetOpen = true
            }
            .padding()
        }
        .sheet(isPresented: $sheetOpen, onDismiss: { activeSheet = nil }) { [activeSheet] in
            switch activeSheet {
            case .addTask:
                ScrollView {
                    AddTaskView(family: extendedFamily)
                        .modifier(GetChildViewHeightModifier(size: $size))
                }
            case .showCalendarDetail:
                if let dateSelected = dateSelected {
                    CalendarDataView(day: dateSelected, tasks: extendedFamily.tasks)
                        .modifier(GetChildViewHeightModifier(size: $size))
                }
            case nil:
                EmptyView()
            }
        }
    }
    
    private var taskResults: [ExtendedTaskItem] {
        if search.isEmpty {
            return extendedFamily.tasks
        } else {
            return extendedFamily.tasks.filter { $0.task.taskName.contains(search) }
        }
    }
    
    private func isEmpty() -> Bool {
        return taskResults.isEmpty
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
    @Environment(\.dismiss) private var dismiss
    
    let day: Date
    
    let tasks: [ExtendedTaskItem]
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                VStack(alignment: .leading) {
                    Text("Tasks Due By")
                        .font(.custom("Sansita-Bold", size: 20))
                    
                    Text(day.getMonthDayYear)
                        .font(.custom("Sansita-ExtraBold", size: 36))
                }
                
                Spacer()
                
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "x.circle.fill")
                        .font(.custom("Sansita-ExtraBold", size: 36))
                }
            }
            .foregroundStyle(Color("slate"))
            
            ScrollView {
                VStack(spacing: 15) {
                    ForEach(selectedTasks, id: \.task.id) { task in
                        VStack {
                            HStack {
                                Text(task.task.taskName)
                                    .font(.custom("Sansita-Bold", size: 20))
                                
                                Spacer()
                                
                                Text(task.assigneeFirstName)
                                    .font(.custom("Sansita-Bold", size: 20))
                            }
                            .foregroundStyle(.black)
                        }
                        .padding()
                        .background(progressColor(progress: task.task.progress))
                        .cornerRadius(10)
                    }
                }
            }
            .frame(height: 250)
        }
        .padding()
    }
    
    var selectedTasks: [ExtendedTaskItem] {
        return tasks.filter {
            return $0.task.finishBy.startOfDay == day
        }
    }
}
