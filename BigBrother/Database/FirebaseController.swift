//
//  FirebaseController.swift
//  BigBrother
//
//  Created by Hasan Qasim on 9/11/19.
//  Copyright © 2019 M Rahman. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class FirebaseController: NSObject, DatabaseProtocol {
    var ID = "b8:27:eb:bb:84:9b"
    
    var listeners = MulticastDelegate<DatabaseListener>()
    var authController: Auth
    var database: Firestore
    var firebaseReadingRef: CollectionReference?
    //var firebaseReadingList: [FirebaseReading]
    
    // storage property is a reference to the root of firebase storage
    //private let storage = Storage.storage().reference()
     
    
    override init() {
        FirebaseApp.configure()
        authController = Auth.auth()
        database = Firestore.firestore()
        //firebaseReadingList = [FirebaseReading]()
        
        super.init()
        
        if UserDefaults.standard.value(forKey: "deviceID") as? String != nil{
            ID = UserDefaults.standard.value(forKey: "deviceID") as! String 
        }
        
        authController.signInAnonymously() { (authResult, error) in
            guard authResult != nil else {
                fatalError("Firebase authentication failed")
            }
            // if auhenticated, attach listener to firebase store
            self.setUpListeners()
        }
    }
    
    func setUpListeners() {
        firebaseReadingRef = database.collection(ID)
        // snapshot listener returns a snapshot of the data for the given reference
        // In this case it is the entire collection of firebase readings
        // this query contains all readings and not just the updated ones, we need to filter them out
        // everytime an update is made to the sensor_readings, this method will be called which will
        // call parseSensorReadingsSnaphot
        firebaseReadingRef?.addSnapshotListener { querySnapshot, error in
            guard (querySnapshot?.documents) != nil else {
                print("error fetching documents: \(error!)")
                return
            }
            self.parseFirebaseReadingSnapshot(snapshot: querySnapshot!)
        }
    }
    
    func parseFirebaseReadingSnapshot(snapshot: QuerySnapshot) {
        // run a for loop to get each document that has had a change. This immediately filters out
        // any readings that hasnt been changed at all this update
        snapshot.documentChanges.forEach { change in
            // get reading data for each document. Data is stored as a dictionary of Any with strings
            // as keys
            let documentRef = change.document.documentID
            guard change.document.data()["filePath"] != nil else {
                return
            }
            let name = change.document.data()["name"] as! String
            let filePath = change.document.data()["filePath"] as! String
            let timestampString = change.document.data()["timestamp"] as! String
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
            let timestamp = dateFormatter.date(from: timestampString)
            
            
            if change.type == .added || change.type == .modified {
                let newReading = FirebaseReading()
                newReading.id = documentRef
                newReading.name = name
                newReading.filePath = filePath
                newReading.timestamp = timestamp!
                downloadImage(at: filePath) { [weak self] image in
                    guard let _ = self else {
                        return
                    }
                    guard let image = image else {
                        return
                    }
                    newReading.image = image
                    Data.firebaseReadingList.append(newReading)
                    self!.listeners.invoke { (listener) in
                               listener.onFirebaseReadingListChange(change: .update, firebaseReading: Data.firebaseReadingList)
                    
                }
               
            }
            
            // for remove we find the reading in the array by ID then remove it
            if change.type == .removed {
                print("removed reading: \(change.document.data())")
                if let index = getReadingIndexByID(reference: documentRef) {
                    Data.firebaseReadingList.remove(at: index)
                }
            }
        }
        listeners.invoke { (listener) in
            listener.onFirebaseReadingListChange(change: .update, firebaseReading: Data.firebaseReadingList)
        }
    }
    }
    
    func getReadingIndexByID(reference: String) -> Int? {
        for reading in Data.firebaseReadingList {
            if reading.id == reference {
                return Data.firebaseReadingList.firstIndex(of: reading)
            }
        }
        return nil
    }
    
    func addListener(listener: DatabaseListener) {
        listeners.addDelegate(listener)
        listener.onFirebaseReadingListChange(change: .update, firebaseReading: Data.firebaseReadingList)
    }
      
    func removeListener(listener: DatabaseListener) {
        listeners.removeDelegate(listener)
    }
    
    // this method asynchronously downlods an image at the specified path from firebase storage
      private func downloadImage(at path: String, completion: @escaping (UIImage?) -> Void) {
        let ref = Storage.storage().reference(withPath: path)
        let megaByte = Int64(2*1024*1024)
        
        ref.getData(maxSize: megaByte) { data, error in
          guard let imageData = data else {
            completion(nil)
            return
          }
          completion(UIImage(data: imageData))
        }
      }

}
