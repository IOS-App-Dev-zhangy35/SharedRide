//
//  RequestCollectionManager.swift
//  SharedRide
//
//  Created by 章音童 on 2022/5/18.
//

import Foundation
import Firebase

class RequestCollectionManager{
    var requests = [Request]()
    
    static let shared = RequestCollectionManager()
    var _collectionRef: CollectionReference
    
    private init(){
        _collectionRef = Firestore.firestore().collection(kTripCollectionPath)
    }
    
    func startListening(for documentID: String, changeListener: @escaping (()->Void)) -> ListenerRegistration{
        //TODO
        _collectionRef = Firestore.firestore().collection(kTripCollectionPath).document(documentID).collection(kRequestCollectionPath)
        
        return _collectionRef.addSnapshotListener {querySnapshot, error in
            guard let documents = querySnapshot?.documents else{
                print("fetching documents: \(error!)")
                return
            }
            self.requests.removeAll()
            for document in documents{
                print("\(document.documentID) -> \(document.data())")
                self.requests.append(Request(documentSnapshot: document))
            }
            changeListener()
        }
    }
    
    func stopListening(_ listenerRegistration: ListenerRegistration?) {
        listenerRegistration?.remove()
    }
    
    func add(r: Request){
        _collectionRef.addDocument(data: [kRequestEmail : r.email,
                                          kRequestStatus: r.status]) {err in
            if let err = err{
                print("Error adding document: \(err)")
            }
        }
    }
    
    func updateStatus(docId: String, status: String){
        _collectionRef.document(docId).updateData([
            kRequestStatus: status,
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
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
