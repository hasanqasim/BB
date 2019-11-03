//
//  HomeViewController.swift
//  BigBrother
//
//  Created by Ayaz Rahman on 29/10/19.
//  Copyright © 2019 Ayaz Rahman. All rights reserved.
//

import UIKit
import RevealingSplashView

class HomeViewController: UIViewController {
    
    
    
    @IBOutlet weak var shineView: ThreePointGradient!

    
    @IBAction func interactionButton(_ sender: Any) {
        performSegue(withIdentifier: "interaction", sender: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let revealingSplashView = RevealingSplashView(iconImage: UIImage(named: "launch-logo")!,iconInitialSize: CGSize(width: 100, height: 100), backgroundColor: UIColor(named: "Primary")!)
        
        //Adds the revealing splash view as a sub view
        self.view.addSubview(revealingSplashView)
        
        //Starts animation
        revealingSplashView.startAnimation(){
            print("Completed")
        }
        
        animateShine()
        // Do any additional setup after loading the view.
    }
    
    
    func animateShine(){
        UIView.animate(withDuration: 5, delay: 0, options: [.repeat,.autoreverse], animations: {
            self.shineView.alpha = 1
        })
    }
    
}
