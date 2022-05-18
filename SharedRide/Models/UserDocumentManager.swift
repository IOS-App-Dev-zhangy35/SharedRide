//
//  UserDocumentManager.swift
//  SharedRide
//
//  Created by 章音童 on 2022/5/16.
//

import Foundation
import Firebase

class UserDocumentManager{
    var _latestDocument: DocumentSnapshot?
    static let shared = UserDocumentManager()
    var _collectionRef: CollectionReference
    private init(){
        _collectionRef = Firestore.firestore().collection(kUserCollectionPath)
    }
    
    func startListening(for documentID: String, changeListener: @escaping (()->Void)) -> ListenerRegistration{
        //TODO
        let query = _collectionRef.document(documentID)
        
        return query.addSnapshotListener {documentSnapshot, error in
            self._latestDocument = nil
            guard let document = documentSnapshot else {
              print("Error fetching document: \(error!)")
              return
            }
            guard let data = document.data() else {
              print("Document data was empty.")
              return
            }
            print("Current data: \(data)")
            self._latestDocument = document
            changeListener()
          }
        
        //TODO
    }
    
    func stopListening(_ listenerRegistration: ListenerRegistration?) {
        listenerRegistration?.remove()
    }
    
    var fName: String{
        if let name = _latestDocument?.get(kUserFirstName){
            return name as! String
        }
        return ""
    }
    
    var lName: String{
        if let name = _latestDocument?.get(kUserLastName){
            return name as! String
        }
        return ""
    }
    
    var phone: Int{
        if let phone = _latestDocument?.get(kUserPhoneNumber){
            return phone as! Int
        }
        return 0
    }
    
    var carModel: String{
        if let model = _latestDocument?.get(kUserCarModel){
            return model as! String
        }
        return ""
    }
    
    var carColor: String{
        if let color = _latestDocument?.get(kUserCarColor){
            return color as! String
        }
        return ""
    }
    
    var carPlate: String{
        if let plate = _latestDocument?.get(kUserCarPlate){
            return plate as! String
        }
        return ""
    }
    
    func addNewUser(uid: String, fName: String?, lName: String?, phone: Int?, model: String?, color: String?, plate: String?){
        let docRef = _collectionRef.document(uid)
        
        docRef.getDocument {(document, error) in
            if let document = document, document.exists{
                print("Document exist")
            }else{
                docRef.setData([
                    kUserFirstName: fName ?? "",
                    kUserLastName: lName ?? "",
                    kUserPhoneNumber: phone ?? 0,
                    kUserCarModel: model ?? "",
                    kUserCarColor: color ?? "",
                    kUserCarPlate: plate ?? ""
                ])
            }
        }
    }
    
    func update(fName: String, lName: String, phone: Int, model: String, color: String, plate: String){
        _collectionRef.document(_latestDocument!.documentID).updateData([
            kUserFirstName: fName,
            kUserLastName: lName,
            kUserPhoneNumber: phone,
            kUserCarModel: model,
            kUserCarColor: color,
            kUserCarPlate: plate
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
}
