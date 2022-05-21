//
//  TripDetailViewController.swift
//  SharedRide
//
//  Created by 章音童 on 2022/5/18.
//

import UIKit
import Firebase
import MessageUI

class TripDetailViewController: UIViewController, MFMessageComposeViewControllerDelegate {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var carLabel: UILabel!
    @IBOutlet weak var plateLabel: UILabel!
    @IBOutlet weak var returnTImeLabel: UILabel!
    @IBOutlet weak var joinButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    var tripListenerRegistration: ListenerRegistration?
    var userListenerRegistration: ListenerRegistration?
    var requestsListenerRegistration: ListenerRegistration?
    var tripDocumentId: String!
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
    
    func displayMessageInterface(phone: String) {
        let composeVC = MFMessageComposeViewController()
        
        // Configure the fields of the interface.
        composeVC.recipients = [phone]
        composeVC.body = "(Sent from SharedRide App)"
        composeVC.messageComposeDelegate = self
        
        // Present the view controller modally.
        if MFMessageComposeViewController.canSendText() {
            self.present(composeVC, animated: true, completion: nil)
        } else {
            print("Can't send messages.")
        }
    }
    
    @IBAction func pressedContactButton(_ sender: Any) {
        displayMessageInterface(phone: String(UserDocumentManager.shared.phone))
    }
    
    @IBAction func pressedJoinRequest(_ sender: Any) {
        joinButton.isEnabled = false
        joinButton.setTitle("Request Sent", for: .disabled)
        let r = Request(email: (AuthManager.shared.currentUser?.email)!, status: "waiting")
        RequestCollectionManager.shared.add(r: r)
    }
    @IBAction func pressedCancelJoin(_ sender: Any) {
        joinButton.isEnabled = true
        joinButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        joinButton.setTitle("Join This Trip", for: .normal)
        for r in RequestCollectionManager.shared.requests{
            if(r.email == AuthManager.shared.currentUser?.email){
                RequestCollectionManager.shared.delete(r.documentId!)
            }
        }
        cancelButton.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cancelButton.isHidden = true
        tripListenerRegistration = TripDocumentManager.shared.startListening(for: tripDocumentId){
            self.requestsListenerRegistration = RequestCollectionManager.shared.startListening(for: self.tripDocumentId){
            self.userListenerRegistration = UserDocumentManager.shared.startListening(for: TripDocumentManager.shared.latestTrip!.driverEmail) {
                self.updateView()
            }
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        TripDocumentManager.shared.stopListening(tripListenerRegistration)
        UserDocumentManager.shared.stopListening(userListenerRegistration)
        RequestCollectionManager.shared.stopListening(requestsListenerRegistration)
    }
    
    func updateView(){
//        quoteLabel.text = moviequote.quote
//        movieLabel.text = moviequote.movie
        var req = Request(email: "", status: "")
        var hasRequested = false
        for r in RequestCollectionManager.shared.requests{
            if(r.email == AuthManager.shared.currentUser?.email){
                req = r
                hasRequested = true
            }
        }
        
        if let t = TripDocumentManager.shared.latestTrip {
        
            if hasRequested {
                joinButton.isEnabled = false
                cancelButton.isHidden = false
                if req.status == "waiting" {
                    joinButton.setTitle("Request Sent", for: .normal)
                }else if req.status == "approved" {
                    joinButton.setTitle("Accepted", for: .normal)
                }
            }else {
                if RequestCollectionManager.shared.requests.count >= t.maxPassenger{
                    joinButton.isEnabled = false
                    joinButton.setTitle("No Seats", for: .normal)
                }
            }
        
            if t.driverEmail == AuthManager.shared.currentUser?.email{
                joinButton.isHidden = true
            }else{
                joinButton.isHidden = false
            }
            
            emailLabel.text = t.driverEmail
            nameLabel.text = UserDocumentManager.shared.fName + " " + UserDocumentManager.shared.lName
            phoneLabel.text = String(UserDocumentManager.shared.phone)
            fromLabel.text = "From: " + t.departure
            toLabel.text = "To: " + t.destination
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd hh:mm"
            timeLabel.text = df.string(from: t.time)
            if t.isRoundTrip{
                returnTImeLabel.isHidden = false
                returnTImeLabel.text = "Return: "+df.string(from: t.returnTime!)
            }else{
                returnTImeLabel.isHidden = true
            }
            carLabel.text = "Car: " + UserDocumentManager.shared.carModel + " (" + UserDocumentManager.shared.carColor + ")"
            plateLabel.text = "Plate Number: " + UserDocumentManager.shared.carPlate
            
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
