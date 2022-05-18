//
//  ViewController.swift
//  SharedRide
//
//  Created by 章音童 on 2022/5/13.
//

import UIKit
import Firebase

class WelcomeViewController: UIViewController {
    var loginHandle: AuthStateDidChangeListenerHandle?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loginHandle = AuthManager.shared.addLoginObserver {
            print("user signed in. show trip list page")
            self.performSegue(withIdentifier: ShowTripsListSegue, sender: self)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        AuthManager.shared.removeObserver(loginHandle)
    }


}

