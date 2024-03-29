//
//  TaskView.swift
//  Home_Harmony
//
//  Created by Daniel Madjar on 3/18/24.
//

import SwiftUI

struct MockData: Identifiable {
    let id = UUID()
    let familyName: String
    let creatorName: String
}

struct FamilyView: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    
    @State private var search: String = ""
    @State private var isAddingFamily: Bool = false
    @State private var size: CGFloat = .zero
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 15) {
                    if viewModel.familiesLoading {
                        ForEach(0..<5) { _ in
                            ShimmerView()
                                .frame(height: 100)
                                .cornerRadius(10)
                        }
                    } else {
                        ForEach(familyResults) { family in
                            NavigationLink {
                                FamilyDetailView(extendedFamily: family)
                            } label: {
                                HStack {
                                    VStack(alignment: .leading) {
                                        HStack {
                                            Text(family.familyName)
                                                .font(.title3)
                                                .fontWeight(.bold)
                                                .foregroundStyle(.black)

                                            Spacer()

                                            Text(family.creator.firstName)
                                                .fontWeight(.semibold)
                                                .padding(.horizontal, 10)
                                                .padding(.vertical, 5)
                                                .background(.red)
                                                .foregroundStyle(.white)
                                                .cornerRadius(5)
                                        }
                                        
                                        Text(numTasks(tasks: family.tasks))
                                    }
                                    
                                    Image(systemName: "chevron.right")
                                        .fontWeight(.semibold)
                                        .foregroundStyle(.black.opacity(0.15))
                                }
                                .modifier(TextModifier(cornerRadius: 10, color: .black.opacity(0.15)))
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
            .navigationTitle("Families")
            .searchable(text: $search)
            .safeAreaInset(edge: .bottom) {
                ButtonComponent(title: "Add Family", image: nil, color: .red) {
                    self.isAddingFamily = true
                }
                .padding()
            }
            .sheet(isPresented: $isAddingFamily, content: {
                AddFamilyView(isAddingFamily: $isAddingFamily)
                    .modifier(GetChildViewHeightModifier(size: $size))
            })
        }
    }
    
    private func numTasks(tasks: [ExtendedTaskItem]) -> String {
        if (tasks.count == 0) {
            return "No tasks to complete!"
        } else if (tasks.count == 1) {
            return "1 task to complete."
        } else {
            return "\(tasks.count) tasks to complete."
        }
    }
    
    private var familyResults: [ExtendedFamily] {
        if search.isEmpty {
            return viewModel.extendedFamilies
        } else {
            return viewModel.extendedFamilies.filter { $0.familyName.contains(search) }
        }
    }
}

#Preview {
    FamilyView()
}
