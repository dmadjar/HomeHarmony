//
//  AddTaskView.swift
//  Home_Harmony
//
//  Created by Daniel Madjar on 3/18/24.
//

import SwiftUI

struct AddTaskView: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel

    @Binding var isAddingTask: Bool
    
    @State private var taskName: String = ""
    @State private var description: String = ""
   // @State private var assignee: User? = nil
    @State private var finishBy: Date = Date.now
    
//    let family: Family
    
    var body: some View {
        VStack(spacing: 30) {
            TextField("Name", text: $taskName)
            
            TextField("Description", text: $description)
            
            HStack {
                Menu("Assign Member To Task") {
//                    ForEach(viewModel.getMembers(family: family)) { member in
//                        Button {
//                           // assignee = member
//                        } label: {
//                            Text("\(member.name ?? "Not Found") \(member.lastName ?? "Not Found")")
//                                .font(.title2)
//                                .fontWeight(.bold)
//                        }
//                    }
                }
            }
            
            DatePicker("Finish by:", selection: $finishBy)
                            .datePickerStyle(GraphicalDatePickerStyle())
                            .frame(maxHeight: 400)
            
            Button {
//                viewModel.addTask(
//                    name: taskName,
//                    description: description,
//                    //memberAssigned: assignee!,
//                    finishBy: finishBy,
//                    family: family
//                )
            } label: {
                Text("Done!")
            }
        }
        .padding(.horizontal)
    }
}

//#Preview {
//    AddTaskView()
//}
