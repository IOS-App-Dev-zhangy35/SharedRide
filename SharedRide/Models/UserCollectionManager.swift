//
//  UserCollectionManager.swift
//  SharedRide
//
//  Created by 章音童 on 2022/5/17.
//

import Foundation
import Firebase

class UserCollectionManager{
    var users = [UserDocument]()
    
    static let shared = UserCollectionManager()
    var _collectionRef: CollectionReference
    
    private init(){
        _collectionRef = Firestore.firestore().collection(kUserCollectionPath)
    }
    
    func startListeningAll(changeListener: @escaping (()->Void)) -> ListenerRegistration{
        //TODO
        let query = _collectionRef.order(by: kUserLastName, descending: true)
        
        return query.addSnapshotListener {querySnapshot, error in
            guard let documents = querySnapshot?.documents else{
                print("fetching documents: \(error!)")
                return
            }
            self.users.removeAll()
            for document in documents{
                print("\(document.documentID) -> \(document.data())")
                self.users.append(UserDocument(documentSnapshot: document))
            }
            changeListener()
        }
    }
    
    func stopListening(_ listenerRegistration: ListenerRegistration?) {
        listenerRegistration?.remove()
    }
    
}
