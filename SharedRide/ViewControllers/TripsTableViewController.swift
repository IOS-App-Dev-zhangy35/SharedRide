//
//  TripsTableViewController.swift
//  SharedRide
//
//  Created by 章音童 on 2022/5/14.
//

import UIKit
import Firebase

class TripsTableViewCell: UITableViewCell{
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var phoeNumberLabel: UILabel!
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var toLabel: UILabel!
    
}

class TripsTableViewController: UITableViewController {
    
    var logoutHandle: AuthStateDidChangeListenerHandle?
    var tripsListenerRegistration: ListenerRegistration?
    var userListenerRegistration: ListenerRegistration?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startListeningForTrips()
        logoutHandle = AuthManager.shared.addLogoutObserver {
            print("someone signed out")
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stopListeningForGroups()
        AuthManager.shared.removeObserver(logoutHandle)
    }
    
    func startListeningForTrips(){
        stopListeningForGroups()
        tripsListenerRegistration = TripsCollectionManager.shared.startListening {
            self.userListenerRegistration = UserCollectionManager.shared.startListeningAll {
                self.tableView.reloadData()
            }
        }
    }
    
    func stopListeningForGroups(){
        TripsCollectionManager.shared.stopListening(tripsListenerRegistration)
        UserCollectionManager.shared.stopListening(userListenerRegistration)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return TripsCollectionManager.shared.trips.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kTripsTableViewCell, for: indexPath) as! TripsTableViewCell

         //Configure the cell...
        //cell.textLabel?.text = movieQuotes[indexPath.row].quote
        //cell.detailTextLabel?.text = movieQuotes[indexPath.row].movie
        
        let t = TripsCollectionManager.shared.trips[indexPath.row]
        for user in UserCollectionManager.shared.users {
            if t.driverEmail == user.email{
                cell.nameLabel.text = user.fName + " " + user.lName
                cell.phoeNumberLabel.text = String(user.phone)
            }
        }
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd hh:mm"
        cell.timeLabel.text = df.string(from: t.time)
        cell.fromLabel.text = "From: " + t.departure
        cell.toLabel.text = "To: " + t.destination
        
        return cell
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == ShowTripDetailSegue{
            if let indexPath = tableView.indexPathForSelectedRow {
                //mqdvc.moviequote = movieQuotes[indexPath.row]
                let mqdvc = segue.destination as! TripDetailViewController
                let mq = TripsCollectionManager.shared.trips[indexPath.row]
                mqdvc.tripDocumentId = mq.documentId!
            }
        }
    }

}
