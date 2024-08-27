//
//  DetailedSeatView.swift
//  SeatSearch
//
//  Created by JP Norton on 8/12/23.
//

import SwiftUI

struct BackButton: View {
    
    @ObservedObject var vm: SeatViewModel
    
    @Binding var show: Bool
    
    var body: some View {
        Button(action: {
            vm.moveBottomSheetMiddle()
            self.show.toggle()
        }, label: {
            HStack {
                Image(systemName: "chevron.backward")
                    .font(.title3)
                Text("Back")
                    .font(.title3)
            }
        }).padding(.horizontal, 20)
    }
}

struct ImageView: View {
    
    var seat: Seat
    
    let randColor: Color = Color(uiColor: .link)
            
    var body: some View {
        let img = seat.optionalInfo.image
        
        if(img != nil) {
            Image(uiImage: img!)
                .resizable()
                .scaledToFill()
                .cornerRadius(35)
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 10)
                .padding(20)

        } else {
            ZStack {
                randColor
                    .aspectRatio(1, contentMode: .fit)
                    .cornerRadius(35)
                    .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 10)
                    .padding(20)
                Image(systemName: Bool.random() ? "chair.fill" : "chair.lounge.fill")
                                        .font(.system(size: 50))
            }
        }
    }
}

struct StarsTypeSizeView: View {
    
    var seat: Seat
            
    var body: some View {
        HStack {
            HStack(spacing: 1) {
                Image(systemName: "star.fill")
                    .foregroundColor(Color.orange)
                Text(String(format: "%.1f", seat.requriedInfo.rating))
                    .bold()
                    .foregroundColor(Color.orange)
                    .lineLimit(1)
            }
            Text(seat.requriedInfo.type.id)
                .lineLimit(1)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color(UIColor.quaternaryLabel))
                .cornerRadius(5)
            Text(seat.requriedInfo.size.id)
                .lineLimit(1)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color(UIColor.quaternaryLabel))
                .cornerRadius(5)
        }
    }
}

struct DistanceView: View {
    
    @ObservedObject var vm: SeatViewModel
    
    var seat: Seat
            
    var body: some View {
        
        let distance: Double = vm.getSeatDistance(seat: seat)
        
        let formattedDistance: String = String(format: "%.0f", distance)
        
        Text("\(formattedDistance) feet away")
            .bold()
            .foregroundColor(Color.blue)
            .lineLimit(1)
    }
}

struct DetailedSeatView: View {
    
    @ObservedObject var vm: SeatViewModel
        
    var seat: Seat
    
    @Binding var showDetailedView: Bool
    
    var body: some View {
        
        VStack(alignment: .leading) {
            BackButton(vm: vm, show: $showDetailedView)
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    ImageView(seat: seat)

                    HStack {
                        VStack(alignment: .leading, spacing: 10) {
                            Text(seat.requriedInfo.name)
                                .font(.title)
                                .bold()
                            
                            StarsTypeSizeView(seat: seat)
                            
                            DistanceView(vm: vm, seat: seat)
                            
                            Spacer()
                            
                            Text(seat.optionalInfo.description ?? "This seat has no description.")
                            
                            Spacer()
                            
                            HStack(alignment: .top) {
                                Text("Pros: ")
                                    .bold()
                                Text(seat.optionalInfo.pros ?? "")
                            }
                            
                            HStack(alignment: .top) {
                                Text("Cons: ")
                                    .bold()
                                Text(seat.optionalInfo.cons ?? "")
                            }
                        }
                        .padding(.horizontal, 20)
                        Spacer()
                    }
                    .padding(.bottom, 150)
                }
            }
            .padding(.horizontal, 20)
        }
    }
}

struct DetailedSeatView_Previews: PreviewProvider {
    static var previews: some View {
        @ObservedObject var vm: SeatViewModel = SeatViewModel()
        
        DetailedSeatView(vm: vm, seat: Seat.data.first!, showDetailedView: BottomSheetMainView(vm: vm, seats: Seat.data).$showDetailedView)
    }
}
