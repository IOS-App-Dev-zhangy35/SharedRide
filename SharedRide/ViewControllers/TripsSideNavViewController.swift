//
//  TripsSideNavViewController.swift
//  SharedRide
//
//  Created by 章音童 on 2022/5/15.
//

import UIKit

class TripsSideNavViewController: UIViewController {
    var tableViewController : TripsTableViewController {
            let navController = presentingViewController as! UINavigationController
            return navController.viewControllers.last as! TripsTableViewController
        }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func pressedAddTrip(_ sender: Any) {
        dismiss(animated: true)
        tableViewController.performSegue(withIdentifier: ShowAddTripSegue, sender: tableViewController)
    }
    @IBAction func pressedViewMyTrip(_ sender: Any) {
        dismiss(animated: true)
        tableViewController.performSegue(withIdentifier: ShowMyTripsSegue, sender: tableViewController)
    }
    @IBAction func pressedSignOut(_ sender: Any) {
        dismiss(animated: true) {
            AuthManager.shared.signOut()
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
