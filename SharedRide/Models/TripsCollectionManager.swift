//
//  TripsCollectionManager.swift
//  SharedRide
//
//  Created by 章音童 on 2022/5/16.
//

import Foundation
import Firebase

class TripsCollectionManager{
    var trips = [Trip]()
    
    static let shared = TripsCollectionManager()
    var _collectionRef: CollectionReference
    
    private init(){
        _collectionRef = Firestore.firestore().collection(kTripCollectionPath)
    }
    
    func startListening(changeListener: @escaping (()->Void)) -> ListenerRegistration{
        //TODO
        var query = _collectionRef.order(by: kTripTime, descending: true)
        query = query.whereField(kTripTime, isGreaterThan: Timestamp.init())
        
        return query.addSnapshotListener {querySnapshot, error in
            guard let documents = querySnapshot?.documents else{
                print("fetching documents: \(error!)")
                return
            }
            self.trips.removeAll()
            for document in documents{
                print("\(document.documentID) -> \(document.data())")
                self.trips.append(Trip(documentSnapshot: document))
            }
            changeListener()
        }
    }
    
    func startListeningMyTrip(changeListener: @escaping (()->Void)) -> ListenerRegistration{
        //TODO
        var query = _collectionRef.order(by: kTripTime, descending: true)
        query = query.whereField(kTripDriverEmail, isEqualTo: AuthManager.shared.currentUser?.email ?? "")
        
        return query.addSnapshotListener {querySnapshot, error in
            guard let documents = querySnapshot?.documents else{
                print("fetching documents: \(error!)")
                return
            }
            self.trips.removeAll()
            for document in documents{
                print("\(document.documentID) -> \(document.data())")
                self.trips.append(Trip(documentSnapshot: document))
            }
            changeListener()
        }
    }
    
    func stopListening(_ listenerRegistration: ListenerRegistration?) {
        listenerRegistration?.remove()
    }
    
    func add(t: Trip){
        _collectionRef.addDocument(data: [kTripDriverEmail : t.driverEmail,
                                             kTripDeparture: t.departure,
                                           kTripDestination: t.destination,
                                          kTripMaxPassenger: t.maxPassenger,
                                                  kTripTime: t.time,
                                            kTripReturnTime: t.returnTime ?? t.time,
                                           kTripIsRoundtrip: t.isRoundTrip
                                         ]) {err in
            if let err = err{
                print("Error adding document: \(err)")
            }
        }
    }
    
    func delete(_ documentID: String){
        _collectionRef.document(documentID).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
}
