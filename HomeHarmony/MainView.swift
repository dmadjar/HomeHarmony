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
        appearance.backgroundColor = UIColor(Color("backgroundColor"))
        appearance.shadowColor = .none
        appearance.shadowImage = nil
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        TabView {
            AudioTestView()
                .tabItem {
                    Label("Audio", systemImage: "mic.fill")
                }
            
            
            TaskView()
                .tabItem {
                    Label("Tasks", systemImage: "checkmark.rectangle.stack")
                }
            
            FamilyView()
                .tabItem {
                    Label("Families", systemImage: "house")
                }
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
        }
        .tint(Color("textColor"))
    }
}

struct MainView_Previews: PreviewProvider {
    static let viewModel = AuthenticationViewModel()

    static var previews: some View {
        MainView()
            .environmentObject(viewModel)
    }
}
