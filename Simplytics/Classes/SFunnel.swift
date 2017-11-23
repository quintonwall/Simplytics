//
//  Funnel.swift
//  A funnel is use case, or flow, within your app that you want to track. eg: you want to create the new user signup flow to see where users are getting stuck or attriting.
//
//  Created by Quinton Wall on 11/21/17.
//

import RealmSwift

@objcMembers class SFunnel : Object {
    
     dynamic var id = 0
     dynamic var name = ""
    ///current date and time
     dynamic var createdAt = Date()
    
     dynamic var events = List<SEvent>()
    
    
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
