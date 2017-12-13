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
    
    /// how long did the event take. defaults to 0.0 if endEvent is not called.
    dynamic var duration = 0.0
    
     /// the application which this tracked event is related to
    dynamic var application : SApplication?
    
    
    
    /// funnel name
    dynamic var funnel = "" {
        didSet {
            funnel = funnel.uppercased()
        }
    }
    
    /// a user defined key value pair of property name + value. eg: 'Add To Cart Tapped' : '3 items'
     dynamic var properties = List<EventProperties>()
    
    
    
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    func asJSON() -> String {
        var propsjson = "[]"
        
        if (properties.count > 0) {
            var ej = "["
            for e in properties {
                ej.append(e.asJSON()+",")
            }
            propsjson = ej.substring(to: ej.index(before: ej.endIndex))+"]"
        }
        
        return "{\"id\": \"\(id)\",\"name\": \"\(name)\",\"funnel\": \"\(funnel.uppercased())\",\"createdAt\": \"\(createdAt.toDateTimeStringWithSeconds())\",\"endedAt\": \"\(endedAt.toDateTimeStringWithSeconds())\",\"properties\": \(propsjson), \"duration\": \(duration), \"application\": \"\(application!.id)\"}"
    }
    
    func calcDuration() {
        duration = Double((endedAt.millisecondsSince1970 - createdAt.millisecondsSince1970) / 1000)
    }
}
