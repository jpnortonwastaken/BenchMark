//
//  TabView.swift
//  SeatSearch
//
//  Created by JP Norton on 8/12/23.
//

import SwiftUI

struct TopNavView: View {
    
    @Binding var showSignInView: Bool
    
    var body: some View {
        TabView {
            MapView()
                .tabItem() {
                    Image(systemName: "map")
                    Text("Map")
                }
            //MyAccountView()
            SettingsView(showSignInView: $showSignInView)
                .tabItem() {
                    Image(systemName: "person.fill")
                    //Text("My Account")
                    Text("Settings")
                }
        }
        .onAppear {
            let tabBarAppearance = UITabBarAppearance()
            tabBarAppearance.configureWithDefaultBackground()
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        }
    }
}

struct TabView_Previews: PreviewProvider {
    static var previews: some View {
        TopNavView(showSignInView: .constant(false))
    }
}
