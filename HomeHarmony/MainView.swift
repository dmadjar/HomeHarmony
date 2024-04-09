//
//  MainView.swift
//  Home_Harmony
//
//  Created by Daniel Madjar on 3/26/24.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    
    init() {
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = UIColor(.white)
        appearance.shadowColor = .none
        appearance.shadowImage = nil
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        TabView {
            TaskView()
                .tabItem {
                    Label("Tasks", systemImage: "checkmark.rectangle.stack")
                }
            
            FamilyView()
                .tabItem {
                    Label("Families", systemImage: "house")
                }
            
            FriendsView()
                .tabItem {
                    Label("Friends", systemImage: "person.2")
                }
            
            ProfileView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
        }
        .tint(Color("slate"))
    }
}

#Preview {
    MainView()
}
