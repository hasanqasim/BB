//
//  ScanViewController.swift
//  BigBrother
//
//  Created by Ayaz Rahman on 2/11/19.
//  Copyright © 2019 M Rahman. All rights reserved.
//

import UIKit

class ScanViewController: UIViewController {

    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func proceedToNextScreen(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let vc = UIStoryboard(name: "Login", bundle: nil).instantiateInitialViewController()
        appDelegate.window?.rootViewController = vc
    }

}
