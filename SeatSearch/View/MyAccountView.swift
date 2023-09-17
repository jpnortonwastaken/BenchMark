//
//  MyAccountView.swift
//  SeatSearch
//
//  Created by JP Norton on 8/12/23.
//

import SwiftUI

struct MyAccountView: View {
    var body: some View {
        ZStack {
            NavigationView {
                VStack {
                    
                }
                .navigationBarTitle("My Account")
            }
            
            RoundedRectangle(cornerRadius: 15)
                .fill(.background)
                .frame(width: 250, height: 80)
                .shadow(color: Color.black.opacity(0.1), radius: 25, x: 0, y: 5)
                .overlay(
                    Text("Nothing to see here yet")
                        .font(.headline)
                )
        }
    }
}

struct MyAccountView_Previews: PreviewProvider {
    static var previews: some View {
        MyAccountView()
    }
}
