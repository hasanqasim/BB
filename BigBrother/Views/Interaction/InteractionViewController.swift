//
//  InteractionViewController.swift
//  BigBrother
//
//  Created by Ayaz Rahman on 3/11/19.
//  Copyright © 2019 M Rahman. All rights reserved.
//

// this class is implemented but never used

import UIKit

class InteractionViewController: UIViewController {

    @IBAction func sendTextButton(_ sender: Any) {
        performSegue(withIdentifier: "options", sender: "Send Text")
    }
    
    @IBAction func sendAudioButton(_ sender: Any) {
        performSegue(withIdentifier: "options", sender: "Send Audio Message")
    }
    
    @IBAction func playMusicButton(_ sender: Any) {
        performSegue(withIdentifier: "options", sender: "Play Music")
    }
    
    
    
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let sender = sender as! String
        let vc = segue.destination as! InteractionOptionsViewController
        vc.option = sender
    }


}
