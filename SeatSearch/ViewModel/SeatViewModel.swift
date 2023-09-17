//
//  ViewModel.swift
//  SeatSearch
//
//  Created by JP Norton on 8/17/23.
//

import Foundation
import CoreLocation
import MapKit
import BottomSheet
import SwiftUI

class SeatViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    @Published var seats: [Seat] = []
    
    var originalSeatsList: [Seat] = []
    
    var bottomSheetPos: BottomSheetPosition = .relative(0.5)
    
    @Published var region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 25.7749, longitude: -97.4194),
            span: MKCoordinateSpan(latitudeDelta: 60.0, longitudeDelta: 60.0)
        )
        
    let locationManager = CLLocationManager()
    
    @Published var mapLocation: Location = Location(latitude: 25.7749, longitude: -97.4194) {
        didSet {
            updateMapRegion(lat: mapLocation.latitude, lon: mapLocation.longitude, span: 0.01)
        }
    }
    
    @Published var userLocation: Location?
    
    @Published var selectedSeat: Seat? = nil
    
    @Published var showDetailedView: Bool = false
    
    override init() {
        super.init()
        
        Task {
            try await initSeatsList()
        }
        
        locationManager.delegate = self
        
        checkLocationAuthorizationStatus()
        
        startLocationUpdates()
    }
    
    func testVM() {
        print("TESTING123")
    }
    
    func initSeatsList() async throws {
        //originalSeatsList = Seat.data
        //originalSeatsList = try await [SeatManager.shared.getSeat(seatId: "3D9E88C1-5CFF-46F3-B602-39C2BD183899")]
        originalSeatsList = try await SeatManager.shared.getAllSeats()
        seats = originalSeatsList
    }
    
    func refreshSeats() async throws {
        originalSeatsList = try await SeatManager.shared.getAllSeats()
        seats = originalSeatsList
    }
    
    func resetSeats() {
        seats = originalSeatsList
    }
    
    func addSeat(id: UUID, name: String, rating: Double, type: SeatType, size: SeatSize, description: String? = nil, pros: String? = nil, cons: String? = nil, image: UIImage? = nil) async throws {
        
        if self.userLocation == nil {
            return
        }
        
        try await SeatManager.shared.createNewSeat(seatId: id.uuidString, name: name, type: type, location: self.userLocation!, size: size, rating: rating, userCreated: "jpn", description: description, pros: pros, cons: cons)
        
        let newSeat = Seat(id: id, requriedInfo: Seat.RequiredInfo(name: name, type: type, location: self.userLocation!, size: size, rating: rating, userCreated: "jpn"),
                           optionalInfo: Seat.OptionalInfo(image: image, description: description, pros: pros, cons: cons))
        
        //originalSeatsList.append(newSeat)
        try await refreshSeats()
        resetSeats()
    }
    
    func reverseSeatsList() {
        seats.reverse()
    }
    
    func shuffleSeatsList() {
        seats.shuffle()
    }
    
    func removeFirstSeatsList() {
        seats.removeFirst()
    }
    
    func removeLastSeatsList() {
        seats.removeLast()
    }
    
    func clearSeatsList() {
        seats.removeAll()
    }
    
    func sortSeatsByDistance() {
        let seatsWithDistance: [(Seat, Double)] = seats.map { seat -> (Seat, Double) in
            let distance: Double = getSeatDistance(seat: seat)
            return (seat, distance)
        }

        let sortedTuples: [(Seat, Double)] = seatsWithDistance.sorted(by: { $0.1 < $1.1 })
        
        let sortedSeats: [Seat] = sortedTuples.map { $0.0 }
        
        seats = sortedSeats
    }
    
    func sortSeatsByNameAToZ() {
        seats.sort { $0.requriedInfo.name < $1.requriedInfo.name }
    }
    
    func sortSeatsByTypeAToZ() {
        seats.sort { $0.requriedInfo.type.id < $1.requriedInfo.type.id }
    }
    
    func sortSeatsBySizeSmallestToLargest() {
        seats.sort { $0.requriedInfo.size.sortOrder < $1.requriedInfo.size.sortOrder }
    }
    
    func sortSeatsBySizeLargestToSmallest() {
        seats.sort { $0.requriedInfo.size.sortOrder > $1.requriedInfo.size.sortOrder }
    }
    
    func sortSeatsByRatingWorstToBest() {
        seats.sort { $0.requriedInfo.rating < $1.requriedInfo.rating }
    }
    
    func sortSeatsByRatingBestToWorst() {
        seats.sort { $0.requriedInfo.rating > $1.requriedInfo.rating }
    }
    
    func filterByRating(stars: Int) {
        resetSeats()
        
        var filterNum: Double = 0.0
        
        switch stars {
        case 1:
            filterNum = 1.0
        case 2:
            filterNum = 2.0
        case 3:
            filterNum = 3.0
        case 4:
            filterNum = 4.0
        case 45:
            filterNum = 45.0
        case 5:
            filterNum = 5.0
        default:
            print("Default case for filterByRating function.")
        }

        var filteredList: [Seat] = []
        
        if filterNum == 45.0 {
            filteredList = seats.filter { $0.requriedInfo.rating >= 4.0 }
        } else {
            filteredList = seats.filter { $0.requriedInfo.rating >= filterNum && $0.requriedInfo.rating < filterNum + 1.0}
        }
        
        seats = filteredList
    }
    
    func updateBottomSheetPos(bsp: BottomSheetPosition) {
        bottomSheetPos = bsp
    }
    
    func startLocationUpdates() {
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
    }
    
    func checkLocationAuthorizationStatus() {
        switch locationManager.authorizationStatus {
            case .authorizedWhenInUse, .authorizedAlways:
                // Location services are authorized, you can request location updates here
                //print("Location services are authorized, you can request location updates here")
                break
            case .notDetermined:
                // Location authorization status is not determined, you can request permission here
                //print("Location authorization status is not determined, you can request permission here")
                locationManager.requestWhenInUseAuthorization()
            case .restricted, .denied:
                // Location services are restricted or denied, handle accordingly
                //print("Location services are restricted or denied, handle accordingly")
                break
            @unknown default:
                // Handle other cases
                break
        }
    }
    
    func requestAllowOnceLocationPermission() {
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latestLocation = locations.last?.coordinate else {
            // show error
            return
        }
        
        DispatchQueue.main.async {
            self.userLocation = Location(latitude: latestLocation.latitude, longitude: latestLocation.longitude)
            //self.mapLocation = Location(latitude: latestLocation.coordinate.latitude, longitude: latestLocation.coordinate.longitude)
        }
    }
    
    func focusUserLocation() {
        if userLocation != nil {
            mapLocation = userLocation!
        }
    }
    
    func updateMapRegion(lat: Double, lon: Double, span: Double) {
        var adjustedLatitude = lat
        let Longitude = lon
        
        if self.bottomSheetPos != .relativeBottom(0.19) {
            adjustedLatitude = lat - 0.0025
        }
        
        withAnimation(.easeInOut) {
            self.region = MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: adjustedLatitude, longitude: Longitude),
                span: MKCoordinateSpan(latitudeDelta: span, longitudeDelta: span)
            )
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager did fail with error: \(error.localizedDescription)")
    }
    
    func getSeatDistance(seat: Seat) -> Double {
        //let userLocation = Location(latitude: 42.3538935823697, longitude: -71.2193435443926)
        let SeatLocation = seat.requriedInfo.location
        
        if self.userLocation == nil {
            return 0.0
        }
        
        return getLocDistance(loc1: self.userLocation!, loc2: SeatLocation)
    }
    
    func getLocDistance(loc1: Location, loc2: Location) -> Double {
        let Location1 = CLLocation(latitude: loc1.latitude, longitude: loc1.longitude)
        let Location2 = CLLocation(latitude: loc2.latitude, longitude: loc2.longitude)
        
        let distanceInMeters = Location1.distance(from: Location2)
        
        let distanceInFeet = distanceInMeters * 3.28084

        return distanceInFeet
    }
}
