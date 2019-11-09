//
//  AddViewController.swift
//  BigBrother
//
//  Created by Ayaz Rahman on 9/11/19.
//  Copyright © 2019 M Rahman. All rights reserved.
//

import UIKit
import AWSS3

class AddViewController: UIViewController {

    var visit = FirebaseReading()
    
    @IBOutlet weak var nameField: UITextField!
    
    @IBAction func saveButton(_ sender: Any) {
        showSpinner()
        let name = nameField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        if name == ""{
            removeSpinner()
            showAlert(title: "Error", message: "Invalid name", action: "Dismiss")
        }
        
        if let data = visit.image!.jpegData(compressionQuality: 0.7) {
            DispatchQueue.main.async(execute: {
                let transferUtility = AWSS3TransferUtility.default()
                let S3BucketName = "bigbrother-faces"
                let expression = AWSS3TransferUtilityUploadExpression()
                let newAWSEntry = "Hugh"
                let rNumber = Int.random(in: 0..<10)
                let key = "\(newAWSEntry)/\(rNumber).jpeg"
                transferUtility.uploadData(data, bucket: S3BucketName, key: key, contentType: "image/jpeg", expression: expression) { (task, error) in
                    if let error = error {
                        print(error.localizedDescription)
                        self.removeSpinner()
                        return
                    }else{
                        self.removeSpinner()
                        //TODO: pop to root home view
                    }
                }
            })
        }
    }
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    

}
