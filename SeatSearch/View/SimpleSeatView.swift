//
//  SimpleSeatView.swift
//  SeatSearch
//
//  Created by JP Norton on 8/11/23.
//

import SwiftUI

struct SimpleSeatView: View {
    
    @ObservedObject var vm: SeatViewModel
    
    let seat: Seat
    
    var body: some View {
        HStack(alignment: .center, spacing: 20) {
            SeatImage(seat: seat)
            
            SimpleSeatInfo(vm: vm, seat: seat)
            
            Spacer()
            
            Chevron()
        }
        .padding(15)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.regularMaterial)
        .cornerRadius(25)
        .overlay(
            RoundedRectangle(cornerRadius: 25)
                .stroke(Color.secondary.opacity(0.4), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 10)
    }
}

struct SeatImage: View {
    
    let seat: Seat
    
    let color: Color = Color(uiColor: .link)
    
    var body: some View {
        let img = seat.optionalInfo.image
        
        if(img != nil) {
            Image(uiImage: img!)
                .resizable()
                .frame(width: 50, height: 50)
                .cornerRadius(15)
                .scaledToFill()
                .clipped()
        } else {
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .foregroundColor(color)
                    .frame(width: 50, height: 50)
                Image(systemName: Bool.random() ? "chair.fill" : "chair.lounge.fill")
                    .foregroundColor(.white)
            }
        }
    }
}

struct SeatNameView: View {
    
    let seat: Seat
    
    var body: some View {
        Text(seat.requriedInfo.name)
            .font(.system(size: 16))
            .bold()
            .lineLimit(1)
    }
}

struct StarsView: View {
    
    let seat: Seat
    
    var body: some View {
        HStack(spacing: 1) {
            Image(systemName: "star.fill")
                .foregroundColor(Color.orange)
                .font(.system(size: 12))
            Text(String(format: "%.1f", seat.requriedInfo.rating))
                .font(.system(size: 14))
                .bold()
                .foregroundColor(Color.orange)
                .lineLimit(1)
        }
    }
}

struct TypeView: View {
    
    let seat: Seat
    
    var body: some View {
        Text(seat.requriedInfo.type.id)
            .font(.system(size: 12))
            .lineLimit(1)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color(UIColor.quaternaryLabel))
            .cornerRadius(5)
    }
}

struct SizeView: View {
    
    let seat: Seat
    
    var body: some View {
        Text(seat.requriedInfo.size.id)
            .font(.system(size: 12))
            .lineLimit(1)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color(UIColor.quaternaryLabel))
            .cornerRadius(5)
    }
}

struct DistanceAwayView: View {
    
    @ObservedObject var vm: SeatViewModel
    
    var seat: Seat
    
    var body: some View {
        
        let distance: Double = vm.getSeatDistance(seat: seat)
        
        let formattedDistance: String = String(format: "%.0f", distance)
        
        Text("\(formattedDistance) feet away")
            .font(.system(size: 14))
            .bold()
            .foregroundColor(Color.blue)
            .lineLimit(1)
    }
}

struct SimpleSeatInfo: View {
    
    @ObservedObject var vm: SeatViewModel
    
    let seat: Seat
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            SeatNameView(seat: seat)
            
            HStack {
                StarsView(seat: seat)
                
                HStack {
                    TypeView(seat: seat)
                    SizeView(seat: seat)
                }
            }
            
            DistanceAwayView(vm: vm, seat: seat)
        }
    }
}

struct Chevron: View {
    
    var body: some View {
        Image(systemName: "chevron.forward")
            .font(.title3)
            .foregroundColor(Color.gray)
            .padding(.trailing)
            .padding(.leading, 0)
    }
}

struct SimpleSeatView_Previews: PreviewProvider {
    static var previews: some View {
        @ObservedObject var vm: SeatViewModel = SeatViewModel()
        
        SimpleSeatView(vm: vm, seat: Seat.data.first!)
            .padding()
    }
}
