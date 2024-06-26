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
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color("backgroundColor"))
            .overlay {
                if familyResults.isEmpty && !viewModel.familiesLoading {
                    EmptyListView(isFamily: true) {
                        if search.isEmpty {
                            Text("It looks like you have no families, try making one to get started!")
                        } else {
                            Text("No families with that name found!")
                        }
                    }
                }
            }
            .safeAreaInset(edge: .top) {
                NavBarComponent(
                    search: $search,
                    title: "Families",
                    content: {}
                )
            }
            .safeAreaInset(edge: .bottom) {
                ButtonComponent(title: "Create Family", image: "plus", backgroundColor: Color("blueColor"), textColor: Color("blackColor")) {
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

struct FamilyView_Previews: PreviewProvider {
    static let viewModel = AuthenticationViewModel()

    static var previews: some View {
        FamilyView()
            .environmentObject(viewModel)
    }
}
