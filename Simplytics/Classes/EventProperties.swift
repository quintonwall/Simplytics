//
//  EventProperties.swift
//  Simplytics
//
//  Created by Quinton Wall on 12/5/17.
//

/**
 EventProperties functions allows the storing of custom defined events in realm.
 It is effectively a [string : string], but realm doesnt support this natively --- it has to be an object.
 
 - name: the name of the event. eg: Button tapped
 - value: a descriptive string. eg: Add to cart on clearance items page.
 */

import RealmSwift

@objcMembers class EventProperties: Object {
    dynamic var name = ""
    dynamic var value = ""
    
    func asJSON() -> String {
        return "{\"name\": \"\(name)\", \"value\": \"\(value)\"}"
    }
    
}
