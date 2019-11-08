//
//  LoginViewController.swift
//  BigBrother
//
//  Created by Ayaz Rahman on 1/11/19.
//  Copyright © 2019 Ayaz Rahman. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBAction func loginButton(_ sender: Any) {
        //Replace if statement with login logic
        guard let email = emailField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else{
            showAlert(message: "email or password is incorrect")
            return}
        guard let password = passwordField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            showAlert(message: "email or password is incorrect")
            return}
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if user != nil && error == nil {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let vc = UIStoryboard(name: "Home", bundle: nil).instantiateInitialViewController()
                appDelegate.window?.rootViewController = vc
            }else{
                self.showAlert(message: "email or password is incorrect")
            }
        }
        
            
        
            
        
    }
    
    func showAlert(message: String){
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "Try Again",
                                   style: .default,
                                   handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    
    
}
