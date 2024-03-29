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
                    if viewModel.isLoading() {
                        ForEach(0..<4) { _ in
                            ShimmerView()
                                .frame(height: 100)
                                .cornerRadius(10)
                        }
                    } else {
                        ForEach(familyResults) { family in
                            NavigationLink {
                                FamilyDetailView(extractedFamily: family)
                            } label: {
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
                                }
                                .modifier(TextModifier(cornerRadius: 10, color: .black.opacity(0.75)))
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
    
    var familyResults: [ExtractedFamily] {
        if search.isEmpty {
            return viewModel.families
        } else {
            return viewModel.families.filter { $0.familyName.contains(search) }
        }
    }
}

#Preview {
    FamilyView()
}
