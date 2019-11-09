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
            showAlert(title: "Error", message: "Email is invalid")
            return
        }
        if passwordField.text != reenterPassword.text {
            showAlert(title: "Error", message: "Passwords don't match")
            return
        }
        
        guard let password = passwordField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            showAlert(title: "Error", message: "Password is invalid")
            return
        }
        
        if password.count < 6 {
            showAlert(title: "Error", message: "Password should be atleast 6 characters long")
            return
        }
        showSpinner()
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if user != nil && error == nil{
                self.dismiss(animated: true, completion: nil)
            }else{
                self.removeSpinner()
                self.showAlert(title: "Error", message: error!.localizedDescription)
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        emailField.delegate = self
        passwordField.delegate = self
        reenterPassword.delegate = self
        // Do any additional setup after loading the view.
    }
    

    

}

extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
