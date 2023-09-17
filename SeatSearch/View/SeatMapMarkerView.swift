//
//  SeatMapMarkerView.swift
//  SeatSearch
//
//  Created by JP Norton on 8/18/23.
//

import SwiftUI

struct SeatMapMarkerView: View {
    
    let accentColor = Color(uiColor: .link)
    
    var body: some View {  
        
        ZStack {
            VStack(spacing: 0) {
                Image(systemName: "chair.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(10)
                    .background(accentColor)
                    .cornerRadius(36)
                
                Image(systemName: "triangle.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(accentColor)
                    .frame(width: 10, height: 10)
                    .rotationEffect(Angle(degrees: 180))
                    .offset(y: -3)
                    .padding(.bottom, 45)
            }
            //.background(.red)
            
            Circle()
                .frame(width: 5, height: 5)
                .foregroundColor(.red)
                .opacity(0)
        }
    }
}

struct SeatMapMarkerView_Previews: PreviewProvider {
    static var previews: some View {
        SeatMapMarkerView()
    }
}
