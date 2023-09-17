//
//  Seat.swift
//  SeatSearch
//
//  Created by JP Norton on 8/11/23.
//

import Foundation
import UIKit
import CoreLocation

struct Seat: Identifiable {
    let id: UUID
    let requriedInfo: RequiredInfo
    let optionalInfo: OptionalInfo
    
    func getLocation(seat: Seat) -> Location {
        return Location(latitude: seat.requriedInfo.location.latitude, longitude: seat.requriedInfo.location.longitude)
    }
    
    func getLatitude(seat: Seat) -> Double {
        return seat.requriedInfo.location.latitude
    }
    
    func getLongitude(seat: Seat) -> Double {
        return seat.requriedInfo.location.longitude
    }
}

extension Seat {
    struct RequiredInfo {
        let name: String
        let type: SeatType
        let location: Location
        let size: SeatSize
        let rating: Double
        let userCreated: String
    }
}

extension Seat {
    struct OptionalInfo {
        let image: UIImage?
        let description: String?
        let pros: String?
        let cons: String?
    }
}

enum SeatType: String, CaseIterable, Identifiable {
    case bench = "Bench"
    case rock = "Rock"
    case chair = "Chair"
    case other = "Other"
    
    var id: String {
        self.rawValue
    }
}

enum SeatSize: String, CaseIterable, Identifiable {
    case child = "Small Child"
    case onePerson = "1 Person"
    case twoPeople = "2 People"
    case threePeople = "3 People"
    case fourPeople = "4 People"
    case fivePlusPeople = "5+ People"
    
    var id: String { self.rawValue }
    
    var sortOrder: Int {
        switch self {
        case .child: return 1
        case .onePerson: return 2
        case .twoPeople: return 3
        case .threePeople: return 4
        case .fourPeople: return 5
        case .fivePlusPeople: return 6
        }
    }
}

struct Location: Equatable {
    let latitude: Double
    let longitude: Double

    static func == (lhs: Location, rhs: Location) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}

extension Seat {
    static var data: [Seat] = [
        .init(id: UUID(),
              requriedInfo: .init(name: "Test Seat 1",
                                  type: .bench,
                                  location: Location(latitude: 42.35397036298061, longitude: -71.21840950164933),
                                  size: .threePeople,
                                  rating: 4.3,
                                  userCreated: "jpn"),
              optionalInfo: .init(image: UIImage(named: "BenchImage"),
                                  description: "This is a description of a test seat.",
                                  pros: "There are a lot of pros to this seat.",
                                  cons: "There are a lot of cons to this seat.")),
        .init(id: UUID(),
              requriedInfo: .init(name: "Test Seat 2",
                                  type: .rock,
                                  location: Location(latitude: 42.35420737304646, longitude: -71.21952561364783),
                                  size: .fivePlusPeople,
                                  rating: 3.7,
                                  userCreated: "jpn"),
              optionalInfo: .init(image: nil,
                                  description: "This is a description of a test seat.",
                                  pros: "There are a lot of pros to this seat.",
                                  cons: "There are a lot of cons to this seat.")),
        .init(id: UUID(),
              requriedInfo: .init(name: "Test Seat 3",
                                  type: .bench,
                                  location: Location(latitude: 42.35577721154569, longitude: -71.22148697898997),
                                  size: .twoPeople,
                                  rating: 2.0,
                                  userCreated: "jpn"),
              optionalInfo: .init(image: nil,
                                  description: "This is a description of a test seat.",
                                  pros: "There are a lot of pros to this seat.",
                                  cons: "There are a lot of cons to this seat.")),
        .init(id: UUID(),
              requriedInfo: .init(name: "Test Seat 4",
                                  type: .other,
                                  location: Location(latitude: 42.36108898757917, longitude: -71.21147496328963),
                                  size: .child,
                                  rating: 1.1,
                                  userCreated: "jpn"),
              optionalInfo: .init(image: nil,
                                  description: "This is a description of a test seat.",
                                  pros: "There are a lot of pros to this seat.",
                                  cons: "There are a lot of cons to this seat.")),
        .init(id: UUID(),
              requriedInfo: .init(name: "Test Seat 5",
                                  type: .chair,
                                  location: Location(latitude: 42.35408715726085, longitude: -71.21875631709247),
                                  size: .onePerson,
                                  rating: 5.0,
                                  userCreated: "jpn"),
              optionalInfo: .init(image: nil,
                                  description: "This is a description of a test seat.",
                                  pros: "There are a lot of pros to this seat.",
                                  cons: "There are a lot of cons to this seat.")),
    ]
}
