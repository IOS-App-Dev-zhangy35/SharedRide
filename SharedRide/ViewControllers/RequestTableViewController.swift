//
//  RequestTableViewController.swift
//  SharedRide
//
//  Created by 章音童 on 2022/5/18.
//

import UIKit
import Firebase

class RequestTableViewCell: UITableViewCell{
    @IBOutlet weak var approveButton: UIButton!
    @IBOutlet weak var emailLabel: UILabel!
    
}

class RequestTableViewController: UITableViewController {
    var tripDocumentId: String!
    var requestsListenerRegistration: ListenerRegistration?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startListening()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stopListening()
    }
    
    func startListening(){
        stopListening()
        requestsListenerRegistration = RequestCollectionManager.shared.startListening(for: tripDocumentId) {
            self.tableView.reloadData()
        }
    }
    
    func stopListening(){
        RequestCollectionManager.shared.stopListening(requestsListenerRegistration)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return RequestCollectionManager.shared.requests.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kRequestTableViewCell, for: indexPath) as! RequestTableViewCell

         //Configure the cell...
        //cell.textLabel?.text = movieQuotes[indexPath.row].quote
        //cell.detailTextLabel?.text = movieQuotes[indexPath.row].movie
        let req = RequestCollectionManager.shared.requests[indexPath.row]
        cell.emailLabel.text = req.email
        if req.status == "approved"{
            cell.approveButton.setTitle("Approved", for: .normal)
            cell.approveButton.isEnabled = false
        }else{
            cell.approveButton.setTitle("Approve", for: .normal)
            cell.approveButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
            cell.approveButton.isEnabled = true
        }
        cell.approveButton.addTarget(self, action: #selector(self.pressedApprove(_ :)), for: .touchUpInside)
        
        return cell
    }
    
    @objc func pressedApprove(_ sender: UIButton){
        let button = sender
        let buttonPostion = button.convert(button.bounds.origin, to: tableView)
        if let indexPath = tableView.indexPathForRow(at: buttonPostion) {
            //mqdvc.moviequote = movieQuotes[indexPath.row]
            let r = RequestCollectionManager.shared.requests[indexPath.row]
            RequestCollectionManager.shared.updateStatus(docId: r.documentId ?? "", status: "approved")
        }
        button.setTitle("Approved", for: .normal)
        button.isEnabled = false
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
