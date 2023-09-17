//
//  ContentView.swift
//  SeatSearch
//
//  Created by JP Norton on 8/11/23.
//

import SwiftUI
import MapKit
import CoreLocationUI
import BottomSheet

struct MapView: View {
    
    @ObservedObject var viewModel: SeatViewModel = SeatViewModel()
    
    @State var showingBottomSheet: Bool = true
    
    @State var bottomSheetPosition: BottomSheetPosition = .relative(0.5)
    
    func updateButtomSheetPosition() {
        viewModel.updateBottomSheetPos(bsp: bottomSheetPosition)
    }
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            
            Map(coordinateRegion: $viewModel.region, showsUserLocation: true, annotationItems: viewModel.seats, annotationContent: { seat in
                MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: seat.getLatitude(seat: seat), longitude: seat.getLongitude(seat: seat))) {
                    SeatMapMarkerView()
                        .scaleEffect(viewModel.mapLocation == seat.getLocation(seat: seat) ? 1 : 0.7)
                        .onTapGesture {
                            updateButtomSheetPosition()
                            viewModel.mapLocation = seat.getLocation(seat: seat)
                            viewModel.selectedSeat = seat
                            viewModel.showDetailedView = true
                        }
                }
            })
                .ignoresSafeArea()
            
            Button(action: {
                updateButtomSheetPosition()
                viewModel.focusUserLocation()
            }) {
                Image(systemName: "location")
                    .font(.title3)
            }
            .frame(width: 50, height: 50)
            .foregroundColor(.primary)
            .background(.thickMaterial)
            .cornerRadius(10)
            .padding(.trailing, 10)
            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 10)

        }
        .bottomSheet(
            bottomSheetPosition: $bottomSheetPosition,
            switchablePositions: [
                .relativeBottom(0.19),
                .relative(0.5),
                .relativeTop(0.975)
            ],
            headerContent: {
                BottomSheetHeaderView(vm: viewModel)
            },
            mainContent: {
                BottomSheetMainView(vm: viewModel, seats: viewModel.seats)
            }
        )
        .enableBackgroundBlur(false)
        .enableFlickThrough(true)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
