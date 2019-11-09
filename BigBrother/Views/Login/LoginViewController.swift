//
//  LoginViewController.swift
//  BigBrother
//
//  Created by Ayaz Rahman on 1/11/19.
//  Copyright © 2019 Ayaz Rahman. All rights reserved.
//

import UIKit
import Firebase
import RevealingSplashView

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBAction func loginButton(_ sender: Any) {
        //Replace if statement with login logic
        guard let email = emailField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else{
            showAlert(title: "Error", message: "email or password is incorrect")
            return}
        guard let password = passwordField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            showAlert(title: "Error", message: "email or password is incorrect")
            return}
        showSpinner()
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if user != nil && error == nil {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let vc = UIStoryboard(name: "Home", bundle: nil).instantiateInitialViewController()
                self.removeSpinner()
                appDelegate.window?.rootViewController = vc
            }else{
                self.removeSpinner()
                self.showAlert(title: "Error", message: "email or password is incorrect")
            }
        }
        
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailField.delegate = self
        passwordField.delegate = self
        //Setting up splashView
        let revealingSplashView = RevealingSplashView(iconImage: UIImage(named: "launch-logo")!,iconInitialSize: CGSize(width: 100, height: 100), backgroundColor: UIColor(named: "Primary")!)
        
        //Adds the revealing splash view as a sub view
        self.view.addSubview(revealingSplashView)
        
        //Starts animation
        revealingSplashView.startAnimation(){
            print("Completed")
        }
        
    }
    
    
    
}
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
