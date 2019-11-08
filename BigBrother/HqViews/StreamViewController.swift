//
//  StreamViewController.swift
//  BigBrother
//
//  Created by Hasan Qasim on 9/11/19.
//  Copyright © 2019 M Rahman. All rights reserved.
//

import UIKit
import MJPEGStreamLib

class StreamViewController: UIViewController {

   var stream: MJPEGStreamLib!
   var url: URL?

   @IBOutlet weak var streamView: UIImageView!
   override func viewDidLoad() {
       super.viewDidLoad()

       // Do any additional setup after loading the view.
       stream = MJPEGStreamLib(imageView: streamView)
       // Your stream url should be here !
       let url = URL(string: "http://192.168.43.227:8910/video_feed")
       stream.contentURL = url
       stream.play() // Play the stream
   }
   
   override func didReceiveMemoryWarning() {
          super.didReceiveMemoryWarning()
      }

}
