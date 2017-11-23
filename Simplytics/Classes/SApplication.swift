//
//  SApplication.swift
//  Stores application level analytics like device OS version etc
//
//  Created by Quinton Wall on 11/21/17.
//

import RealmSwift

@objcMembers class SApplication : Object {
    
     dynamic var id = 0
     dynamic var name = ""
    /// current date and time
     dynamic var createdAt = Date()
     dynamic var osVersion = ""
     dynamic var device = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
}
