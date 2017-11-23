//
//  SEvent.swift
//  Realm representation of Simplytic events
//
//  Created by Quinton Wall on 11/21/17.
//

import RealmSwift

@objcMembers class SEvent : Object {
    
     dynamic var id = 0
     dynamic var name = ""
    
    //current date and time
     dynamic var createdAt = Date()
    
    /// a user defined key value pair of property name + value. eg: 'Add To Cart Tapped' : '3 items'
     dynamic var properties = List<EventProperties>()
    
    
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    
}
