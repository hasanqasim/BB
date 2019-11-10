//
//  ScanViewController.swift
//  BigBrother
//
//  Created by Ayaz Rahman on 2/11/19.
//  Copyright © 2019 M Rahman. All rights reserved.
//

// Reference for this code sections: https://www.youtube.com/watch?v=4Zf9dHDJ2yU

import UIKit
import AVFoundation

class ScanViewController: UIViewController {

    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var cancelButtonRef: UIButtonX!
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    var video = AVCaptureVideoPreviewLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        captureSession()
    }
    
    func proceedToNextScreen(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let vc = UIStoryboard(name: "Login", bundle: nil).instantiateInitialViewController()
        appDelegate.window?.rootViewController = vc
    }

}

extension ScanViewController: AVCaptureMetadataOutputObjectsDelegate{
    func captureSession(){
        //Creating the session
        let session = AVCaptureSession()
        
        //Define Capture
        guard let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else {
            errorLabel.alpha = 1
            return  }
        
        do{
            
            let input = try AVCaptureDeviceInput(device: captureDevice)
            session.addInput(input)
            
        }catch{
            print("Error in catch")
        }
        
        let output = AVCaptureMetadataOutput()
        session.addOutput(output)
        
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        output.metadataObjectTypes = [AVMetadataObject.ObjectType.code128]
        
        video = AVCaptureVideoPreviewLayer(session: session)
        video.frame = view.layer.bounds
        
        view.layer.addSublayer(video)
        
        self.view.bringSubviewToFront(cancelButtonRef)
        
        session.startRunning()
        
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects.count != 0{
            if let object = metadataObjects[0] as? AVMetadataMachineReadableCodeObject{
                if object.type == AVMetadataObject.ObjectType.code128{
                    let alert = UIAlertController(title: "Bar Code", message: object.stringValue, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Verify", style: .default, handler: { (success) in
                        //print(object.stringValue)
                        UserDefaults.standard.set(object.stringValue, forKey: "deviceID")
                        self.proceedToNextScreen()
                    }))
                    alert.addAction(UIAlertAction(title: "Retake", style: .cancel, handler: nil))
                    present(alert, animated: true)
                }
            }
            
        }
    }
}
