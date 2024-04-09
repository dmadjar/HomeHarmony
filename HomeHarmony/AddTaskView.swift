//
//  AddTaskView.swift
//  Home_Harmony
//
//  Created by Daniel Madjar on 3/18/24.
//

import SwiftUI

struct AddTaskView: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var taskName: String = ""
    @State private var description: String = ""
    @State private var assignee: CustomUser? = nil
    @State private var finishBy: Date = Date.now
    
    let family: ExtendedFamily
    
    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            Text("Create Task")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            TextField("Name", text: $taskName)
                .modifier(TextModifier(cornerRadius: 10, color: .black.opacity(0.75)))
            
            TextField("Description", text: $description)
                .modifier(TextModifier(cornerRadius: 10, color: .black.opacity(0.75)))
            
            HStack {
                Menu("Assign Member To Task") {
                    ForEach(family.members) { member in
                        Button {
                            self.assignee = member
                        } label: {
                            Text("\(member.firstName) \(member.lastName)")
                                .font(.title2)
                                .fontWeight(.bold)
                        }
                    }
                }
                
                Spacer()
                
                if let assignee = assignee {
                    HStack {
                        Text(assignee.firstName)
                        
                        Text(assignee.lastName)
                    }
                }
            }
            .modifier(TextModifier(cornerRadius: 10, color: .black.opacity(0.75)))
            
            DatePicker("Finish by:", selection: $finishBy)
                            .datePickerStyle(GraphicalDatePickerStyle())
                            .frame(maxHeight: 400)
            
            ButtonComponent(title: "Done!", image: nil) {
                Task {
                    await addTask()
                    dismiss()
                }
            }
        }
        .padding()
    }
    
    private func addTask() async {
        if let assignee = assignee, let assigneeId = assignee.id, let familyID = family.id {
            await viewModel.createTask(
                familyID: familyID,
                taskName: taskName,
                description: description,
                assigneeID: assigneeId,
                assignee: assignee,
                finishBy: finishBy
            )
        }
    }
}

//#Preview {
//    AddTaskView()
//}
