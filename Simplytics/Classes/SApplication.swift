//
//  SApplication.swift
//  Stores application level analytics like device OS version etc
//
//  Created by Quinton Wall on 11/21/17.
//

import RealmSwift

@objcMembers class SApplication : Object {
    
    dynamic var id =  ""
    dynamic var salesforceid = ""
    dynamic var uuid = ""
    dynamic var device = ""
    dynamic var model = ""
    dynamic var appname = ""
    dynamic var appversion = ""
    dynamic var buildnumber = ""
    
    let funnels = List<SFunnel>()

    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    
}
