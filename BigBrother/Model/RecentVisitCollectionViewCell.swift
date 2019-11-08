//
//  RecentVisitCollectionViewCell.swift
//  BigBrother
//
//  Created by Ayaz Rahman on 8/11/19.
//  Copyright © 2019 M Rahman. All rights reserved.
//

import UIKit

class RecentVisitCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageViewX!
    @IBOutlet weak var nameField: UILabel!
    
    /*var visit: [String] {
        didSet{
            self.updateUI()
        }
    }
    
    func updateUI(){
        if let visit = visit {
            imageView.image = UIImage(named: visit[0])
            nameField.text = visit[1]
        }
    }*/
}
