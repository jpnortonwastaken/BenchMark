//
//  BottomSheetView.swift
//  SeatSearch
//
//  Created by JP Norton on 8/11/23.
//

import SwiftUI

struct RefreshButtonView: View {
    
    @ObservedObject var vm: SeatViewModel
        
    var body: some View {
        Button {
            Task {
                do {
                    try await vm.refreshSeats()
                } catch {
                    print("Failed to refresh seats: \(error)")
                }
            }
        } label: {
            Image(systemName: "arrow.clockwise.circle.fill")
                .symbolRenderingMode(.hierarchical)
                .font(.title)
                .foregroundColor(.blue)
        }
    }
}

struct SortButtonView: View {
    
    @ObservedObject var vm: SeatViewModel
        
    var body: some View {
        Menu {
            Button("Reverse", action: { vm.reverseSeatsList()
            })
            Button("Shuffle", action: { vm.shuffleSeatsList()
            })
            Button("Sort by distance", action: { vm.sortSeatsByDistance()
            })
            Button("Sort by name (A->Z)", action: { vm.sortSeatsByNameAToZ()
            })
            Button("Sort by type (A->Z)", action: { vm.sortSeatsByTypeAToZ()
            })
            Button("Sort by size (Small->Large)", action: { vm.sortSeatsBySizeSmallestToLargest()
            })
            Button("Sort by size (Large->Small)", action: { vm.sortSeatsBySizeLargestToSmallest()
            })
            Button("Sort by rating (Worst->Best)", action: { vm.sortSeatsByRatingWorstToBest()
            })
            Button("Sort by rating (Best->Worst)", action: { vm.sortSeatsByRatingBestToWorst()
            })
        } label: {
            Image(systemName: "arrow.up.arrow.down.circle.fill")
                .symbolRenderingMode(.hierarchical)
                .font(.title)
                .foregroundColor(.blue)
        }
    }
}

struct FilterButtonView: View {
    
    @ObservedObject var vm: SeatViewModel
        
    var body: some View {
        Menu {
            Button("Remove First", action: { vm.removeFirstSeatsList()
            })
            Button("Remove Last", action: { vm.removeLastSeatsList()
            })
            Button("Clear", action: { vm.clearSeatsList()
            })
            Button("Show All", action: { vm.resetSeats()
            })
            Button("Show only 1 star", action: { vm.filterByRating(stars: 1)
            })
            Button("Show only 2 stars", action: { vm.filterByRating(stars: 2)
            })
            Button("Show only 3 stars", action: { vm.filterByRating(stars: 3)
            })
            Button("Show only 4 stars", action: { vm.filterByRating(stars: 4)
            })
            Button("Show only 4+ stars", action: { vm.filterByRating(stars: 45)
            })
            Button("Show only 5 stars", action: { vm.filterByRating(stars: 5)
            })
        } label: {
            Image(systemName: "line.3.horizontal.decrease.circle.fill")
                .symbolRenderingMode(.hierarchical)
                .font(.title)
                .foregroundColor(.blue)
        }
    }
}

struct BottomSheetHeaderView: View {
    
    @State var showingSheet: Bool = false
    
    @ObservedObject var vm: SeatViewModel
    
    var body: some View {
        HStack {
            Text("Seats")
                .font(.title)
                .bold()
                .lineLimit(1)
            
            Spacer()
            
            RefreshButtonView(vm: vm)
            
            SortButtonView(vm: vm)
            
            FilterButtonView(vm: vm)
            
            Button {
                self.showingSheet.toggle()
            } label: {
                Image(systemName: "plus.circle.fill")
                    .font(.title)
            }
        }
        .padding([.leading, .trailing])
        .padding(.bottom, 20)
        .sheet(isPresented: $showingSheet, content: {
            AddSeatView(vm: vm, showingSheet: $showingSheet)
        })
    }
}

struct SeatListView: View {
    
    @ObservedObject var vm: SeatViewModel
        
    @Binding var showDetailedView: Bool
        
    var body: some View {
        ZStack {
            if vm.seats.isEmpty {
                VStack {
                    Spacer()
                    ProgressView("Loading seats...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding(.bottom, 125)
                    Spacer()
                }
            } else {
                ScrollView {
                    ForEach(vm.seats) { seat in
                        Button(action: {
                            vm.mapLocation = Location(latitude: seat.requriedInfo.location.latitude, longitude: seat.requriedInfo.location.longitude)
                            vm.moveBottomSheetUp()
                            vm.selectedSeat = seat
                            vm.showDetailedView = true
                        }, label: {
                            SimpleSeatView(vm: vm, seat: seat)
                                .padding([.leading, .trailing])
                        })
                        .foregroundColor(.primary)
                    }
                    .padding(.top, 2)
                    .padding(.bottom, 100)
                }
                .refreshable {
                    Task {
                        do {
                            try await vm.refreshSeats()
                        } catch {
                            print("Failed to refresh seats: \(error)")
                        }
                    }
                }
                .transition(.move(edge: .leading))
                //.animation(.default, value: showDetailedView)
            }
        }
    }
}

struct SeatDetailView: View {
    
    @ObservedObject var vm: SeatViewModel
    
    var seat: Seat
    
    @Binding var showDetailedView: Bool
    
    var body: some View {
        DetailedSeatView(vm: vm, seat: seat, showDetailedView: $showDetailedView)
            .transition(.move(edge: .trailing))
            //.animation(.default, value: showDetailedView)
            .zIndex(0)
    }
}
 
struct BottomSheetMainView: View {
    
    @ObservedObject var vm: SeatViewModel
    
    @State var seats: [Seat]
        
    @State var showDetailedView: Bool = false
    
    var body: some View {
        ZStack(alignment: .top) {
            if vm.showDetailedView, let selectedSeat = vm.selectedSeat {
                SeatDetailView(vm: vm, seat: selectedSeat, showDetailedView: $vm.showDetailedView)
            } else {
                SeatListView(vm: vm, showDetailedView: $vm.showDetailedView)
            }
        }
        .animation(.spring(), value: vm.showDetailedView)
    }
}

struct BottomSheetView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        @ObservedObject var vm: SeatViewModel = SeatViewModel()
        
        VStack(spacing: 0) {
            BottomSheetHeaderView(vm: vm)
            BottomSheetMainView(vm: vm, seats: Seat.data)
        }
    }
}
