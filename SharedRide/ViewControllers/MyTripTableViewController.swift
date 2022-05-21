//
//  MyTripTableViewController.swift
//  SharedRide
//
//  Created by 章音童 on 2022/5/18.
//

import UIKit
import Firebase

class MyTripTableViewCell: UITableViewCell{
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
}

class MyTripTableViewController: UITableViewController {
    var tripsListenerRegistration: ListenerRegistration?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = editButtonItem
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startListeningForTrips()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stopListeningForGroups()
    }
    
    func startListeningForTrips(){
        stopListeningForGroups()
        tripsListenerRegistration = TripsCollectionManager.shared.startListeningMyTrip {
            self.tableView.reloadData()
        }
    }
    
    func stopListeningForGroups(){
        TripsCollectionManager.shared.stopListening(tripsListenerRegistration)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return TripsCollectionManager.shared.trips.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kMyTripTableViewCell, for: indexPath) as! MyTripTableViewCell

         //Configure the cell...
        //cell.textLabel?.text = movieQuotes[indexPath.row].quote
        //cell.detailTextLabel?.text = movieQuotes[indexPath.row].movie
        
        let t = TripsCollectionManager.shared.trips[indexPath.row]
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd hh:mm"
        cell.timeLabel.text = df.string(from: t.time)
        cell.fromLabel.text = "From: " + t.departure
        cell.toLabel.text = "To: " + t.destination
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
//            movieQuotes.remove(at: indexPath.row)
//            tableView.reloadData()
            let toDelete = TripsCollectionManager.shared.trips[indexPath.row]
            TripsCollectionManager.shared.delete(toDelete.documentId!)
        } 
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
         if segue.identifier == ShowRequestListSegue{
             if let indexPath = tableView.indexPathForSelectedRow {
                 //mqdvc.moviequote = movieQuotes[indexPath.row]
                 let mqdvc = segue.destination as! RequestTableViewController
                 let mq = TripsCollectionManager.shared.trips[indexPath.row]
                 mqdvc.tripDocumentId = mq.documentId!
             }
         }
     }

}
