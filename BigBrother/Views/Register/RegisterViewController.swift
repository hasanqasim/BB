//
//  RegisterViewController.swift
//  BigBrother
//
//  Created by Ayaz Rahman on 1/11/19.
//  Copyright © 2019 M Rahman. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var reenterPassword: UITextField!
    
    
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func signUpButton(_ sender: Any) {
        guard let email = emailField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else{
            showAlert(message: "Email is invalid")
            return
        }
        if passwordField.text != reenterPassword.text {
            showAlert(message: "Passwords don't match")
            return
        }
        
        guard let password = passwordField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            showAlert(message: "Password is invalid")
            return
        }
        
        if password.count < 6 {
            showAlert(message: "Password should be atleast 6 characters long")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if user != nil && error == nil{
                self.dismiss(animated: true, completion: nil)
            }else{
                self.showAlert(message: error.debugDescription)
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    func showAlert(message: String){
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "Try Again",
                                   style: .default,
                                   handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }

}
