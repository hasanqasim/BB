//
//  HomeViewController.swift
//  BigBrother
//
//  Created by Ayaz Rahman on 29/10/19.
//  Copyright © 2019 Ayaz Rahman. All rights reserved.
//

import UIKit
import RevealingSplashView
import Firebase

class HomeViewController: UIViewController {
    
    
    @IBOutlet weak var recentCollectionView: UICollectionView!
    
    @IBOutlet weak var shineView: ThreePointGradient!

    @IBOutlet weak var liveStreamRef: UIButtonX!
    @IBOutlet weak var interactionRef: UIButtonX!
    @IBOutlet weak var contactsRef: UIButtonX!
    
    @IBOutlet weak var bottomMenu: UIView!
    @IBOutlet weak var lightFill: UIViewX!
    @IBOutlet weak var upButtonRef: UIButtonX!
    
    @IBAction func upButton(_ sender: Any) {
        if lightFill.transform == CGAffineTransform.identity{
            UIView.animate(withDuration: 1, animations: {
                self.lightFill.transform = CGAffineTransform(scaleX: 11, y: 11)
                self.bottomMenu.transform = CGAffineTransform(translationX: 0, y: -107)
                self.upButtonRef.transform = CGAffineTransform(rotationAngle: self.radians(180))
            }) { (true) in
                UIView.animate(withDuration: 0.5) {
                    self.toggleButtonAlpha()
                }
            }
        }else{
            UIView.animate(withDuration: 0.5, animations: {
                self.toggleButtonAlpha()
            }) { (true) in
                UIView.animate(withDuration: 1) {
                    self.lightFill.transform = .identity
                    self.bottomMenu.transform = .identity
                    self.upButtonRef.transform = .identity
                }
            }
        }
        
        
    }
    
    
    @IBAction func signoutButton(_ sender: Any) {
        try? Auth.auth().signOut()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let vc = UIStoryboard(name: "Login", bundle: nil).instantiateInitialViewController()
        appDelegate.window?.rootViewController = vc
    }
    
    
    @IBAction func interactionButton(_ sender: Any) {
        performSegue(withIdentifier: "interaction", sender: nil)
    }
    
    var visits = [["default-profile", "Unknown"], ["default-profile", "Unknown"],["default-profile", "Unknown"], ["default-profile", "Unknown"],["default-profile", "Unknown"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Making the bottom menu button disappear
        liveStreamRef.alpha = 0
        contactsRef.alpha = 0
        interactionRef.alpha = 0
        
        //Setting the data source for the collection view
        recentCollectionView.dataSource = self
        
        //Setting up splashView
        let revealingSplashView = RevealingSplashView(iconImage: UIImage(named: "launch-logo")!,iconInitialSize: CGSize(width: 100, height: 100), backgroundColor: UIColor(named: "Primary")!)
        
        //Adds the revealing splash view as a sub view
        self.view.addSubview(revealingSplashView)
        
        //Starts animation
        revealingSplashView.startAnimation(){
            print("Completed")
        }
        
        animateShine()
        
    }
    
    
    func animateShine(){
        UIView.animate(withDuration: 5, delay: 0, options: [.repeat,.autoreverse], animations: {
            self.shineView.alpha = 1
        })
    }
    
    func radians(_ degrees: Double)-> CGFloat{
        return CGFloat(degrees * .pi / degrees)
    }
    
    func toggleButtonAlpha(){
        let alpha = CGFloat(liveStreamRef.alpha == 0 ? 1:0)
        liveStreamRef.alpha = alpha
        contactsRef.alpha = alpha
        interactionRef.alpha = alpha
    }
    
}

extension HomeViewController: UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.visits.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecentVisitCollectionViewCell", for: indexPath) as! RecentVisitCollectionViewCell
        let visit = visits[indexPath.item]
        cell.imageView.image = UIImage(named: visit[0])
        cell.nameField.text = visit[1]
        return cell
    }
}

