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
    
    weak var databaseController: DatabaseProtocol?
    
    @IBOutlet weak var recentCollectionView: UICollectionView!
    
    @IBOutlet weak var shineView: ThreePointGradient!

    @IBOutlet weak var liveStreamRef: UIButtonX!
    
    
    @IBOutlet weak var bottomMenu: UIView!
    @IBOutlet weak var lightFill: UIViewX!
    @IBOutlet weak var upButtonRef: UIButtonX!
    
    
    // animates the menu into view
    fileprivate func animateIn() {
        UIView.animate(withDuration: 1, animations: {
            self.lightFill.transform = CGAffineTransform(scaleX: 11, y: 11)
            self.bottomMenu.transform = CGAffineTransform(translationX: 0, y: -117)
            self.upButtonRef.transform = CGAffineTransform(rotationAngle: self.radians(180))
        }) { (true) in
            UIView.animate(withDuration: 0.5) {
                self.toggleButtonAlpha()
            }
        }
    }
    
    
    // animates the view out of view
    fileprivate func animateIdentity() {
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
    
    @IBAction func upButton(_ sender: Any) {
        if lightFill.transform == CGAffineTransform.identity{
            animateIn()
        }else{
            animateIdentity()
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
    
    var visits = [FirebaseReading]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //make clear navigation bar
        //navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        
        //Making the bottom menu button disappear
        liveStreamRef.alpha = 0
        
        
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
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        databaseController?.addListener(listener: self)
        if lightFill.transform != CGAffineTransform.identity{
            animateIdentity()
        }
        //messageLabel.text = Data.firebaseReadingList[0].name
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        databaseController?.removeListener(listener: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateShine()
    }
    
    
    func animateShine(){
        self.shineView.alpha = 0
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
        cell.imageView.image = visit.image
        cell.nameField.text = visit.name
        return cell
    }
}

extension HomeViewController: DatabaseListener{
    func onFirebaseReadingListChange(change: DatabaseChange, firebaseReading: [FirebaseReading]) {
        visits = firebaseReading.sorted(by: { $0.timestamp > $1.timestamp })
        visits = Array(visits.prefix(5))
        recentCollectionView.reloadData()
    }
}

