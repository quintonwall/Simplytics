//
//  SEvent.swift
//  Realm representation of Simplytic events
//
//  Created by Quinton Wall on 11/21/17.
//

import RealmSwift

@objcMembers class SEvent : Object {
    
     dynamic var id = ""
     dynamic var name = ""
    
    /// current date and time
     dynamic var createdAt = Date()
    
    /// optional end time if you want to track duration of an event
    /// defaults to createdAt time, call simplytics.endEvent to set
    dynamic var endedAt = Date()
    
     /// the application which this tracked event is related to
    dynamic var application : SApplication?
    
    /// a user defined key value pair of property name + value. eg: 'Add To Cart Tapped' : '3 items'
     dynamic var properties = List<EventProperties>()
    
   
    
    
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    
}
