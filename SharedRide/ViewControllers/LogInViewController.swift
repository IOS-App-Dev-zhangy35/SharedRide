//
//  LogInViewController.swift
//  SharedRide
//
//  Created by 章音童 on 2022/5/13.
//

import UIKit

class LogInViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func pressedLogIn(_ sender: Any) {
        let email = emailTextField.text!
        let password = passwordTextField.text!
        print("pressed login user. \(email) : \(password)")
        AuthManager.shared.logInExistingEmailPasswordUser(email: email, password: password)
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
