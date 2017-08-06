//
//  DataStorage.swift
//  AppIdeas
//
//  Created by Vandan Patel on 8/5/17.
//  Copyright © 2017 Vandan Patel. All rights reserved.
//

import Foundation
import Firebase



struct DataStorage {
    
    static let sharedInstance = DataStorage()
    
    var databaseRef = Database.database().reference()
    
}
