//
//  VisitListTableViewCell.swift
//  BigBrother
//
//  Created by Ayaz Rahman on 9/11/19.
//  Copyright © 2019 M Rahman. All rights reserved.
//

import UIKit

class VisitListTableViewCell: UITableViewCell {

   
    @IBOutlet weak var picView: UIImageViewX!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    

    func setValue(_ visit: FirebaseReading){
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "HH:mm MMM dd,yyyy"
        dateFormatterPrint.timeZone = TimeZone(abbreviation: "GMT")
        picView.image = visit.image
        nameLabel.text = visit.name
        dateLabel.text = dateFormatterPrint.string(from: visit.timestamp)
    }
}
