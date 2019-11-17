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
        //check if name is empty
        if name == ""{
            removeSpinner()
            showAlert(title: "Error", message: "Invalid name", action: "Dismiss")
            return
        }
        //proceed with storing the image in AWSS3 with name label
        if let data = visit.image!.jpegData(compressionQuality: 0.7) {
            DispatchQueue.main.async(execute: {
                let transferUtility = AWSS3TransferUtility.default()
                let S3BucketName = "bigbrother-faces"
                let expression = AWSS3TransferUtilityUploadExpression()
                let newAWSEntry = name!
                let rNumber = Int.random(in: 0..<10)
                let key = "\(newAWSEntry)/\(rNumber).jpeg"
                transferUtility.uploadData(data, bucket: S3BucketName, key: key, contentType: "image/jpeg", expression: expression) { (task, error) in
                    if let error = error {
                        print(error.localizedDescription)
                        DispatchQueue.main.async {
                            self.removeSpinner()
                            self.showAlert(title: "Error", message: error.localizedDescription)
                        }
                        return
                    }else{
                        DispatchQueue.main.async {
                            self.removeSpinner()
                            let alert = UIAlertController(title: "Success", message: "New entry has been added. It will be recognized as \(name!) next time.", preferredStyle: UIAlertController.Style.alert)
                            let action = UIAlertAction(title: "dismiss", style: .default) { (success) in
                                self.dismiss(animated: true, completion: nil)
                            }
                            alert.addAction(action)
                            self.present(alert, animated: true, completion: nil)
                        }
                        
                    }
                }
            })
        }
        removeSpinner()
    }
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    

}
