//
//  ModelObjects.swift
//  SharedRide
//
//  Created by 章音童 on 2022/5/16.
//

import Foundation
import Firebase

class Trip{
    var driverEmail: String
    var departure: String
    var destination: String
    var maxPassenger: Int
    var time: Date
    var returnTime: Date?
    var documentId: String?
    var isRoundTrip: Bool
    
    init(driverEmail: String, depart: String, dest: String, max: Int, time: Date, returnTime: Date?, isRoundtrip: Bool){
        self.driverEmail = driverEmail
        self.departure = depart
        self.destination = dest
        self.maxPassenger = max
        self.time = time
        self.returnTime = returnTime
        self.isRoundTrip = isRoundtrip
    }
    
    init(documentSnapshot: DocumentSnapshot){
        let data = documentSnapshot.data()
        self.documentId = documentSnapshot.documentID
        self.driverEmail = data?[kTripDriverEmail] as? String ?? ""
        self.departure = data?[kTripDeparture] as? String ?? ""
        self.destination = data?[kTripDestination] as? String ?? ""
        self.maxPassenger = data?[kTripMaxPassenger] as? Int ?? 0
        let time = data?[kTripTime] as? Timestamp
        self.time = time!.dateValue()
        if let time2 = data?[kTripReturnTime] as? Timestamp{
            self.returnTime = time2.dateValue()
        }
        self.isRoundTrip = data?[kTripIsRoundtrip] as? Bool ?? false
    }
    
}

class UserDocument{
    var fName : String
    var lName : String
    var email : String
    var phone : Int
    var carModel : String
    var carColor : String
    var carPlate : String
    
    init(documentSnapshot: DocumentSnapshot){
        let data = documentSnapshot.data()
        self.fName = data?[kUserFirstName] as? String ?? ""
        self.lName = data?[kUserLastName] as? String ?? ""
        self.email = documentSnapshot.documentID
        self.phone = data?[kUserPhoneNumber] as? Int ?? 0
        self.carModel = data?[kUserCarModel] as? String ?? ""
        self.carColor = data?[kUserCarColor] as? String ?? ""
        self.carPlate = data?[kUserCarPlate] as? String ?? ""
    }
}

class Request{
    var email : String
    var status : String
    var documentId: String?
    
    init(email: String, status: String){
        self.email = email
        self.status = status
    }
    
    init(documentSnapshot: DocumentSnapshot){
        let data = documentSnapshot.data()
        self.documentId = documentSnapshot.documentID
        self.email = data?[kRequestEmail] as? String ?? ""
        self.status = data?[kRequestStatus] as? String ?? ""
    }
}
