//
//  DetailViewController.swift
//  BigBrother
//
//  Created by Ayaz Rahman on 9/11/19.
//  Copyright © 2019 M Rahman. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    var visit: FirebaseReading = FirebaseReading()
    
    @IBOutlet weak var imageView: UIImageViewX!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var addButtonRef: UIButton!
    
    
    @IBAction func addButton(_ sender: Any) {
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //checking if there is no visitor name then skip everything
        if visit.name != ""{
            let dateFormatterPrint = DateFormatter()
            dateFormatterPrint.dateFormat = "HH:mm MMM dd,yyyy"
            dateFormatterPrint.timeZone = TimeZone(abbreviation: "GMT")
            imageView.image = visit.image
            nameLabel.text = visit.name
            dateLabel.text = "Detected Time: \(dateFormatterPrint.string(from: visit.timestamp))"
        }
        //show the add button only if there is an unknown face
        if visit.name != "unknown" {
            addButtonRef.alpha = 0
        }
        
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! AddViewController
        vc.visit = self.visit
    }
    
    

}
