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
                                FamilyComponent(extendedFamily: family)
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
            .background(Color("lightGray"))
            .safeAreaInset(edge: .top) {
                NavBarComponent(
                    search: $search,
                    title: "Families",
                    content: {}
                )
            }
            .safeAreaInset(edge: .bottom) {
                ButtonComponent(title: "Create Family", image: "plus") {
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
