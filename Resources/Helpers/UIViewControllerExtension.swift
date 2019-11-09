//
//  UIViewControllerExtension.swift
//  BigBrother
//
//  Created by Ayaz Rahman on 9/11/19.
//  Copyright © 2019 M Rahman. All rights reserved.
//

import Foundation
import UIKit

fileprivate var activityView: UIView?

extension UIViewController{
    //Add an overlay view with a spinner
    func showSpinner(){
        activityView = UIView(frame: self.view.bounds)
        activityView?.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
        activityIndicator.center = activityView!.center
        activityIndicator.startAnimating()
        activityView?.addSubview(activityIndicator)
        self.view.addSubview(activityView!)
    }
    
    //Remove the overlay view with the spinner
    func removeSpinner(){
        activityView?.removeFromSuperview()
        activityView = nil
    }
    
    func showAlert(title: String, message: String, action: String = "Try Again"){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: action,
                                   style: .default,
                                   handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}
