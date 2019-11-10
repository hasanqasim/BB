//
//  InteractionOptionsViewController.swift
//  BigBrother
//
//  Created by Ayaz Rahman on 4/11/19.
//  Copyright © 2019 M Rahman. All rights reserved.
//

//This class was implemented but never used

import UIKit

class InteractionOptionsViewController: UIViewController {

    @IBOutlet weak var sendMessageView: UIView!
    @IBOutlet weak var sendAudioView: UIView!
    
    @IBOutlet weak var playMusicView: UIView!
    
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    var option: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let action = self.option else{return}
        print(action)
        switch action {
            case "Send Text":
                sendMessageView.alpha = 1
                sendAudioView.alpha = 0
                playMusicView.alpha = 0
                break
            case "Send Audio Message":
                sendMessageView.alpha = 0
                sendAudioView.alpha = 1
                playMusicView.alpha = 0
                
                break
            case "Play Music":
                sendMessageView.alpha = 0
                sendAudioView.alpha = 0
                playMusicView.alpha = 1
                break
            default: break
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
