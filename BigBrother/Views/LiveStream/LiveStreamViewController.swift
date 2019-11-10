//
//  LiveStreamViewController.swift
//  BigBrother
//
//  Created by Ayaz Rahman on 10/11/19.
//  Copyright © 2019 M Rahman. All rights reserved.
//

import UIKit
import MJPEGStreamLib

class LiveStreamViewController: UIViewController {

    @IBOutlet weak var streamView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let stream = MJPEGStreamLib(imageView: streamView)
        // Your stream url should be here !
        stream.didStartLoading = { [unowned self] in
            self.showSpinner()
        }
        
        stream.didFinishLoading = { [unowned self] in
            self.removeSpinner()
        }
        
        let url = URL(string: "http://192.168.43.227:8910/video_feed")
        stream.contentURL = url
        stream.play() // Play the stream
        
    }
    

    

}
