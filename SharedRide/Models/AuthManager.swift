//
//  AuthManager.swift
//  SharedRide
//
//  Created by 章音童 on 2022/5/16.
//

import Foundation
import Firebase

class AuthManager{
    static let shared = AuthManager()
    private init(){
        
    }
    
    var currentUser: User? {
        Auth.auth().currentUser
    }
    
    var isSignedIn: Bool {
        get{
            return currentUser != nil
        }
        set{
            
        }
    }
    
    func addLoginObserver(callback: @escaping (() -> Void)) -> AuthStateDidChangeListenerHandle {
        return Auth.auth().addStateDidChangeListener {auth, user in
            if(user != nil){
                callback();
            }
        }
    }
    
    func addLogoutObserver(callback: @escaping (() -> Void)) -> AuthStateDidChangeListenerHandle {
        return Auth.auth().addStateDidChangeListener {auth, user in
            if(user == nil){
                callback();
            }
        }
    }
    
    func removeObserver(_ authDidChangeHandle: AuthStateDidChangeListenerHandle?){
        if let authHandle = authDidChangeHandle {
            Auth.auth().removeStateDidChangeListener(authHandle)
        }
        
    }
    
    func signInNewEmailPasswordUser(email: String, password: String) {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    print("There was an error creating the user: \(error)")
                    return
                }
                print("User created.")
            }
    }
    
    func logInExistingEmailPasswordUser(email: String, password: String){
        Auth.auth().signIn(withEmail: email, password: password) {authResult, error in
            if let error = error {
                print("error: \(error)");
                return
            }
            print("user logged in")
            
        }
    }
    
    func signOut(){
        do{
            try Auth.auth().signOut()
        }catch{
            print("sign out failed: \(error)")
        }
    }
}
