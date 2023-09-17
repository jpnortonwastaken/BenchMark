//
//  TabView.swift
//  SeatSearch
//
//  Created by JP Norton on 8/12/23.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            MapView()
                .tabItem() {
                    Image(systemName: "map")
                    Text("Map")
                }
            MyAccountView()
                .tabItem() {
                    Image(systemName: "person.fill")
                    Text("My Account")
                }
        }
    }
}

struct TabView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
