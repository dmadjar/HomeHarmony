//
//  CalendarDataView.swift
//  HomeHarmony
//
//  Created by Daniel Madjar on 4/10/24.
//

import SwiftUI

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
