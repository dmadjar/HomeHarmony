//
//  TaskView.swift
//  Home_Harmony
//
//  Created by Daniel Madjar on 3/18/24.
//

import SwiftUI

struct FamilyDetailView: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    
    @State private var isAddingTask: Bool = false
    
    let extractedFamily: ExtractedFamily
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 15) {
                    Text("Tasks")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    ForEach(viewModel.tasks) { task in
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
            .safeAreaInset(edge: .bottom) {
                Button {
                    self.isAddingTask = true
                } label: {
                    Text("Add Task")
                }
                .modifier(ButtonModifier(bgColor: .red, textColor: .white))
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
}

//#Preview {
//    TaskView()
//}
