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
                    Label("Profile", systemImage: "person.circle")
                }
        }
    }
}

#Preview {
    MainView()
}
