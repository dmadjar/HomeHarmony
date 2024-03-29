//
//  ProgressIndicatorView.swift
//  HomeHarmony
//
//  Created by Daniel Madjar on 3/28/24.
//

import SwiftUI

struct ProgressIndicator: Identifiable {
    let id = UUID()
    let label: String
    let color: Color
    let index: Int
}

struct ProgressIndicatorView: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    
    let constantProgressIndicators: [ProgressIndicator] = [
        ProgressIndicator(label: "Started", color: .red, index: 1),
        ProgressIndicator(label: "In Progress", color: .yellow, index: 2),
        ProgressIndicator(label: "Finished", color: .green, index: 3)
    ]
   
    let taskCurrentProgress: Int
    
    let taskID: String?
   
    var body: some View {
        HStack {
            ForEach(taskCurrentProgress..<constantProgressIndicators.count, id: \.self) { ind in
                Button {
                    if let taskID = taskID {
                        let progress = constantProgressIndicators[ind].index
                        
                        Task {
                            await viewModel.updateTaskProgress(taskID: taskID, progress: progress)
                        }
                        
                        print("Getting here.")
                    } else {
                        print("Could not unwrap taskID.")
                    }
                } label: {
                    Text(constantProgressIndicators[ind].label)
                        .fontWeight(.medium)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(constantProgressIndicators[ind].color)
                        .foregroundStyle(.black)
                        .cornerRadius(5)
                }
            }
        }
    }
}

struct ProgressModifier: ViewModifier {
    let bgColor: Color
    
    func body(content: Content) -> some View {
        content
            .fontWeight(.semibold)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(bgColor)
            .foregroundStyle(.black)
            .cornerRadius(5)
    }
}

struct IndividualProgressView: View {
    let progress: Int
    
    var body: some View {
        switch progress {
        case 1:
            Text("Started")
                .modifier(ProgressModifier(bgColor: .red))
        case 2:
            Text("In Progress")
                .modifier(ProgressModifier(bgColor: .yellow))
        case 3:
            Text("Finished")
                .modifier(ProgressModifier(bgColor: .green))
        default:
            Text("Not Started")
                .fontWeight(.medium)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(.black.opacity(0.15), lineWidth: 2)
                )
                .foregroundStyle(.black)
        }
    }
}
