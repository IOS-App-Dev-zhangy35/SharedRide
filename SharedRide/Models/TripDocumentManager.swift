//
//  TripDocumentManager.swift
//  SharedRide
//
//  Created by 章音童 on 2022/5/18.
//

import Foundation
import Firebase

class TripDocumentManager{
    var latestTrip: Trip?
    static let shared = TripDocumentManager()
    var _collectionRef: CollectionReference
    private init(){
        _collectionRef = Firestore.firestore().collection(kTripCollectionPath)
    }
    
    func startListening(for documentID: String, changeListener: @escaping (()->Void)) -> ListenerRegistration{
        //TODO
        let query = _collectionRef.document(documentID)
        
        return query.addSnapshotListener {documentSnapshot, error in
            guard let document = documentSnapshot else {
              print("Error fetching document: \(error!)")
              return
            }
            guard let data = document.data() else {
              print("Document data was empty.")
              return
            }
            print("Current data: \(data)")
            self.latestTrip = Trip(documentSnapshot: document)
            changeListener()
          }
        
        //TODO
    }
    
    func stopListening(_ listenerRegistration: ListenerRegistration?) {
        listenerRegistration?.remove()
    }
    
    func update(depart: String, dest: String, max: Int, time: Date, returnTime: Date){
        let docId = latestTrip!.documentId
        _collectionRef.document(docId!).updateData([
                                                kTripDeparture: depart,
                                               kTripDestination: dest,
                                              kTripMaxPassenger: max,
                                                      kTripTime: time,
                                                kTripReturnTime: returnTime,
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
    
}
