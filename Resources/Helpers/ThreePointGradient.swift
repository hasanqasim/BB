//
//  ThreePointGradient.swift
//  BigBrother
//
//  Created by Ayaz Rahman on 29/10/19.
//  Copyright © 2019 Ayaz Rahman. All rights reserved.
//

import UIKit

class ThreePointGradient: UIView {

    // MARK: - Gradient
    
    @IBInspectable var firstColor: UIColor = UIColor.white {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var secondColor: UIColor = UIColor.white {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var thirdColor: UIColor = UIColor.white {
        didSet {
            updateView()
        }
    }
    
    override class var layerClass: AnyClass{
        get{ return CAGradientLayer.self}
    }
    
    func updateView() {
        let layer = self.layer as! CAGradientLayer
        layer.colors = [ firstColor.cgColor, secondColor.cgColor, thirdColor.cgColor ]
        
        layer.startPoint = CGPoint(x: 0, y: 0)
        layer.endPoint = CGPoint(x: 0, y: 1)
        
    }
    
    // MARK: - Border
    
    @IBInspectable public var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }

}
