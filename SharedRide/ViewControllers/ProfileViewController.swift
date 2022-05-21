//
//  ProfileViewController.swift
//  SharedRide
//
//  Created by 章音童 on 2022/5/18.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {
    @IBOutlet weak var fNameTextField: UITextField!
    @IBOutlet weak var lNameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var carModelTextField: UITextField!
    @IBOutlet weak var carColorTextField: UITextField!
    @IBOutlet weak var carPlateTextField: UITextField!
    
    var userListenerRegistration: ListenerRegistration?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        userListenerRegistration = UserDocumentManager.shared.startListening(for: AuthManager.shared.currentUser!.email!){
            self.updateView()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        UserDocumentManager.shared.stopListening(userListenerRegistration)
    }
    
    @IBAction func pressedUpdate(_ sender: Any) {
        UserDocumentManager.shared.update(fName: fNameTextField.text!, lName: lNameTextField.text!, phone: Int(phoneTextField.text!)!, model: carModelTextField.text!, color: carColorTextField.text!, plate: carPlateTextField.text!)
        navigationController?.popViewController(animated: true)
    }
    
    func updateView(){
        fNameTextField.text = UserDocumentManager.shared.fName
        lNameTextField.text = UserDocumentManager.shared.lName
        phoneTextField.text = String(UserDocumentManager.shared.phone)
        carModelTextField.text = UserDocumentManager.shared.carModel
        carColorTextField.text = UserDocumentManager.shared.carColor
        carPlateTextField.text = UserDocumentManager.shared.carPlate
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
