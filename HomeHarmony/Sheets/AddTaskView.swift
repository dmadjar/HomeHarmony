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
    @State private var taskColor: Int = 0
    
    let colors = [
        Color("redColor"), Color("orangeColor"), Color("yellowColor"), Color("greenColor"), Color("blueColor")
    ]
    
    let family: ExtendedFamily
    
    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            Text("Create Task")
                .font(.custom("Sansita-ExtraBold", size: 36))
            
            VStack(spacing: 10) {
                HStack {
                    Image(systemName: "text.badge.checkmark")
                    
                    TextField("", text: $taskName,
                              prompt: Text("Task Name")
                        .font(.custom("Sansita-Regular", size: 20))
                        .foregroundStyle(Color("textColor").opacity(0.5))
                    )
                }
                
                RoundedRectangle(cornerRadius: 10)
                    .frame(height: 2)
            }
            .foregroundStyle(Color("textColor").opacity(0.5))
            
            VStack(spacing: 10) {
                HStack {
                    Image(systemName: "pencil")
                    
                    TextField("", text: $description,
                              prompt: Text("Description")
                        .font(.custom("Sansita-Regular", size: 20))
                        .foregroundStyle(Color("textColor").opacity(0.5))
                    )
                }
                
                RoundedRectangle(cornerRadius: 10)
                    .frame(height: 2)
            }
            .foregroundStyle(Color("textColor").opacity(0.5))
            
            
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
                    Text(assignee.firstName)
                }
            }
            .padding()
            .font(.custom("Sansita-Bold", size: 17))
            .background(Color("secondaryColor"))
            .cornerRadius(10)
            
            DatePicker("Finish by:", selection: $finishBy)
                .font(.custom("Sansita-Bold", size: 17))
            
            VStack(alignment: .leading, spacing: 20) {
                Text("Task Color")
                    .font(.custom("Sansita-Bold", size: 17))
                
                HStack(spacing: 30) {
                    Spacer()
                    
                    ForEach(Array(zip(colors.indices, colors)), id: \.0) { index, color in
                        Button {
                            withAnimation {
                                self.taskColor = index
                            }
                        } label: {
                            Circle()
                                .frame(
                                    width: colorSelected(index) ? 40 : 30,
                                    height: colorSelected(index) ? 40 : 30
                                )
                                .foregroundStyle(color)
                                .overlay {
                                    Circle()
                                        .stroke(
                                            colorSelected(index)
                                            ? Color("textColor")
                                            : color,
                                            lineWidth: 4
                                        )
                                }
                        }
                    }
                    
                    Spacer()
                }
            }
            
            ButtonComponent(title: "Done!", image: nil, backgroundColor: Color("blueColor"), textColor: Color("blackColor")) {
                Task {
                    await addTask()
                    dismiss()
                }
            }
        }
        .padding()
        .background(Color("backgroundColor"))
    }
    
    private func colorSelected(_ index: Int) -> Bool {
        return taskColor == index
    }
    
    private func addTask() async {
        if let assignee = assignee, let assigneeId = assignee.id, let familyID = family.id {
            await viewModel.createTask(
                familyID: familyID,
                taskName: taskName,
                description: description,
                assigneeID: assigneeId,
                assignee: assignee,
                finishBy: finishBy,
                taskColor: taskColor
            )
        }
    }
}

struct AddTaskView_Previews: PreviewProvider {
    static let viewModel = AuthenticationViewModel()

    static let family = ExtendedFamily(
        familyName: "Family Name",
        creator: CustomUser(firstName: "Daniel", lastName: "Madjar"),
        members: [],
        tasks: []
    )
    
    static var previews: some View {
        AddTaskView(family: family)
            .environmentObject(viewModel)
    }
}
