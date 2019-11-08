//
//  ViewController.swift
//  BigBrother
//
//  Created by Hasan Qasim on 9/11/19.
//  Copyright © 2019 M Rahman. All rights reserved.
//

import UIKit
import AWSS3

class ViewController: UIViewController, DatabaseListener {

    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    
    weak var databaseController: DatabaseProtocol?
    var firebaseReadingList = [FirebaseReading]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.\
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
       
    }
    
    @IBAction func sendToAWS(_ sender: Any) {
        guard let image = firebaseReadingList[0].image else {
            return
        }
        
        if let data = image.jpegData(compressionQuality: 0.7) {
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
                        return
                    }
                }
            })
        }
        
    }
    

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        databaseController?.addListener(listener: self)
        //messageLabel.text = Data.firebaseReadingList[0].name
    }
    
    func onFirebaseReadingListChange(change: DatabaseChange, firebaseReading: [FirebaseReading]) {
        firebaseReadingList = firebaseReading
        if firebaseReadingList.count != 0 {
            firebaseReadingList = firebaseReadingList.sorted(by: { $0.timestamp < $1.timestamp })
            messageLabel.text = firebaseReadingList[firebaseReading.endIndex-1].name
            imageView.image = firebaseReadingList[firebaseReading.endIndex-1].image
                
        }
    }
}
