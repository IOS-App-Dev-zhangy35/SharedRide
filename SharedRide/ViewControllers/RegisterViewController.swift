//
//  RegisterViewController.swift
//  SharedRide
//
//  Created by 章音童 on 2022/5/13.
//

import UIKit

class RegisterViewController: UIViewController {
    @IBOutlet weak var fNameTextField: UITextField!
    @IBOutlet weak var lNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var carModelTextField: UITextField!
    @IBOutlet weak var carColorTextField: UITextField!
    @IBOutlet weak var plateNumTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func pressedSignUp(_ sender: Any) {
        let email = emailTextField.text!
        let password = passwordTextField.text!
        let fName = fNameTextField.text!
        let lName = lNameTextField.text!
        let phone = phoneTextField.text!
        let carModel = carModelTextField.text!
        let carColor = carColorTextField.text!
        let carPlate = plateNumTextField.text!
        print("pressed register. \(email) : \(password)")
        AuthManager.shared.signInNewEmailPasswordUser(email: email, password: password)
        UserDocumentManager.shared.addNewUser(uid: email, fName: fName, lName: lName, phone: Int(phone), model: carModel, color: carColor, plate: carPlate)
        dismiss(animated: true)
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
