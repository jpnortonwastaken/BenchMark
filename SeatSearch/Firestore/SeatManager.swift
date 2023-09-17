//
//  SeatManager.swift
//  SeatSearch
//
//  Created by JP Norton on 9/7/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

final class SeatManager {
    static let shared = SeatManager()
    private init() { }
    
    func createNewSeat(seatId: String, name: String, type: SeatType, location: Location, size: SeatSize, rating: Double, userCreated: String, description: String?, pros: String?, cons: String?) async throws {
        var seatData: [String:Any] = [
            "seatId" : seatId,
            "name" : name,
            "type" : type.rawValue,
            "location" : GeoPoint(latitude: location.latitude, longitude: location.longitude),
            "size" : size.rawValue,
            "rating" : rating,
            "userCreated" : userCreated,
            "dateCreated" : Timestamp()
        ]
        if let d = description {
            seatData["description"] = d
        }
        if let p = pros {
            seatData["pros"] = p
        }
        if let c = cons {
            seatData["cons"] = c
        }
        
        try await Firestore.firestore().collection("seats").document(seatId).setData(seatData, merge: false)
    }
    
    func getSeat(seatId: String) async throws -> Seat {
        let snapshot = try await Firestore.firestore().collection("seats").document(seatId).getDocument()
        
        guard let data = snapshot.data(), let seatId = data["seatId"] as? String else {
            throw URLError(.badServerResponse)
        }
        
        let name = data["name"] as! String
        let type = data["type"] as! String
        let location = data["location"] as! GeoPoint
        let size = data["size"] as! String
        let rating = data["rating"] as! Double
        let userCreated = data["userCreated"] as! String
        let description = data["description"] as? String
        let pros = data["pros"] as? String
        let cons = data["cons"] as? String
        
        return Seat(id: UUID(uuidString: seatId)!, requriedInfo: Seat.RequiredInfo(name: name, type: SeatType(rawValue: type)!, location: Location(latitude: location.latitude, longitude: location.longitude), size: SeatSize(rawValue: size)!, rating: rating, userCreated: userCreated), optionalInfo: Seat.OptionalInfo(image: nil, description: description, pros: pros, cons: cons))
    }
    
    func getAllSeats() async throws -> [Seat] {
        let querySnapshot = try await Firestore.firestore().collection("seats").getDocuments()
        
        var seats: [Seat] = []
        
        for document in querySnapshot.documents {
            let data = document.data()
            
            guard let seatId = data["seatId"] as? String,
                  let name = data["name"] as? String,
                  let type = data["type"] as? String,
                  let location = data["location"] as? GeoPoint,
                  let size = data["size"] as? String,
                  let rating = data["rating"] as? Double,
                  let userCreated = data["userCreated"] as? String else {
                // Handle any missing or invalid data in the document
                continue
            }
            
            let description = data["description"] as? String
            let pros = data["pros"] as? String
            let cons = data["cons"] as? String
            
            let seat = Seat(
                id: UUID(uuidString: seatId)!,
                requriedInfo: Seat.RequiredInfo(
                    name: name,
                    type: SeatType(rawValue: type)!,
                    location: Location(latitude: location.latitude, longitude: location.longitude),
                    size: SeatSize(rawValue: size)!,
                    rating: rating,
                    userCreated: userCreated
                ),
                optionalInfo: Seat.OptionalInfo(image: nil, description: description, pros: pros, cons: cons)
            )
            
            seats.append(seat)
        }
        
        return seats
    }
}
