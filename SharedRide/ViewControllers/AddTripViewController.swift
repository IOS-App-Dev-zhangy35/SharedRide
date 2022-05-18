//
//  AddTripViewController.swift
//  SharedRide
//
//  Created by 章音童 on 2022/5/18.
//

import UIKit

class AddTripViewController: UIViewController {
    @IBOutlet weak var departTextField: UITextField!
    @IBOutlet weak var destTextField: UITextField!
    @IBOutlet weak var numPassengerTextField: UITextField!
    @IBOutlet weak var timeField: UITextField!
    @IBOutlet weak var returnTimeField: UITextField!
    @IBOutlet weak var oneWayButton: UIButton!
    @IBOutlet weak var roundTripButton: UIButton!
    
    let datePicker1 = UIDatePicker()
    let datePicker2 = UIDatePicker()
    var time = Date()
    var returnTime = Date()
    var isRoundTrip = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createDatePicker()
        returnTimeField.isHidden = true
        oneWayButton.isSelected = true
        isRoundTrip = false
        roundTripButton.isSelected = false
        // Do any additional setup after loading the view.
    }
    
    @IBAction func pressedOneWAy(_ sender: Any) {
        oneWayButton.isSelected = true
        roundTripButton.isSelected = false
        isRoundTrip = false
        returnTimeField.isHidden = true
    }
    @IBAction func pressedRoundtrip(_ sender: Any) {
        oneWayButton.isSelected = false
        roundTripButton.isSelected = true
        isRoundTrip = true
        returnTimeField.isHidden = false
    }
    @IBAction func pressedCreate(_ sender: Any) {
        if isRoundTrip == false{
            returnTime = time
        }
        let trip = Trip(driverEmail: (AuthManager.shared.currentUser?.email)!, depart: departTextField.text!, dest: destTextField.text!, max: Int(numPassengerTextField.text!)!, time: time, returnTime: returnTime, isRoundtrip: isRoundTrip)
        TripsCollectionManager.shared.add(t: trip)
        navigationController?.popViewController(animated: true)
    }
    
    func createDatePicker() {
        timeField.textAlignment = .center
        
        let toolbar1 = UIToolbar()
        toolbar1.sizeToFit()
        
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressedTime))
        toolbar1.setItems([doneBtn], animated: true)
        
        timeField.inputAccessoryView = toolbar1
        datePicker1.preferredDatePickerStyle = .wheels
        timeField.inputView = datePicker1
        
        returnTimeField.textAlignment = .center
        
        let toolbar2 = UIToolbar()
        toolbar2.sizeToFit()
        
        let doneBtn2 = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressedReturnTime))
        toolbar2.setItems([doneBtn2], animated: true)
        
        returnTimeField.inputAccessoryView = toolbar2
        datePicker2.preferredDatePickerStyle = .wheels
        returnTimeField.inputView = datePicker2
    }
    
    @objc func donePressedTime(){
        let fromatter = DateFormatter()
        fromatter.dateStyle = .medium
        fromatter.timeStyle = .short
        timeField.text = fromatter.string(from: datePicker1.date)
        time = datePicker1.date
        self.view.endEditing(true)
    }
    
    @objc func donePressedReturnTime(){
        let fromatter = DateFormatter()
        fromatter.dateStyle = .medium
        fromatter.timeStyle = .short
        returnTimeField.text = fromatter.string(from: datePicker2.date)
        returnTime = datePicker2.date
        self.view.endEditing(true)
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
