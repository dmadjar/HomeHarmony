//
//  MainView.swift
//  Home_Harmony
//
//  Created by Daniel Madjar on 3/26/24.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            TaskView()
                .tabItem {
                    Label("Tasks", systemImage: "list.bullet.rectangle")
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
        .tint(.black)
    }
}

#Preview {
    MainView()
}
