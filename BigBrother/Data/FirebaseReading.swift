//
//  FirebaseReading.swift
//  BigBrother
//
//  Created by Hasan Qasim on 9/11/19.
//  Copyright © 2019 M Rahman. All rights reserved.
//

import UIKit

class FirebaseReading: NSObject {
    var id: String
           var name: String
           var filePath: String
           var image: UIImage? = nil
           var timestamp: Date
           
           override init() {
               self.id = ""
               self.name = ""
               self.filePath = ""
               self.timestamp = Date()
           }
}
