//
//  DatabaseProtocol.swift
//  BigBrother
//
//  Created by Hasan Qasim on 9/11/19.
//  Copyright © 2019 M Rahman. All rights reserved.
//

import Foundation

enum DatabaseChange {
    case add
    case remove
    case update
}

protocol DatabaseListener: AnyObject {
    func onFirebaseReadingListChange(change: DatabaseChange, firebaseReading: [FirebaseReading])
}

protocol DatabaseProtocol: AnyObject {
    func addListener(listener: DatabaseListener)
    func removeListener(listener: DatabaseListener)
}

