//
//  Simplytics.swift
//  simplytics
//
//  Created by Quinton Wall on 11/21/17.
//

import RealmSwift
import Realm
import SwiftlySalesforce

@objcMembers
open class Simplytics {
    
    /// swiftlysalesforce connection
    public var salesforce : Salesforce!
    
    /// the mobile app being tracked
    var application : SApplication!
    
    public init() {
    }
    
    // MARK: Logging
   
    /**
     * Log a specifc event.
     * returns a unique id for the event which can be used to time an event duration by calling simplytics.endEvent.
     */
    open func logEvent(_ event: String, funnel:String?=nil, withProperties properties: [String: String]?=nil) -> String {
        let ep = List<EventProperties>()
        
        if properties != nil {
            for (key,value) in properties! {
                let e = EventProperties()
                e.name = key
                e.value = value
                ep.append(e)
            }
        }
        let realm = try! Realm()
        let uuid = UUID().uuidString
        try! realm.write() {
            realm.create(SEvent.self, value: [uuid, event, Date(), Date(), application, ep])
        }
        return uuid
    }
    
    public func endEvent(_ eventid : String) {
       let realm = try! Realm()
        try! realm.write {
             realm.create(SEvent.self, value: ["id": eventid, "endedAt": Date()], update: true)
        }
    }
    
    public func logError(_ name: String, funnel:String?=nil, message: String?, properties: [String: Any]? = nil, error: Error?) {
    }
    
    open func logApp(_ name : String) {
        let realm = try! Realm()
        print("SIMPLYTICS using default Realm @ \(Realm.Configuration.defaultConfiguration.fileURL!)")
        try! realm.write() {
            let model : String =  UIDevice().model
            let appname : String = name
            let appversion: String = Bundle.main.releaseVersionNumber!
            let buildnumber: String = Bundle.main.buildVersionNumber!
            let device: String = UIDevice().type.rawValue
            
            application = SApplication(value: [device, model, appname, appversion, buildnumber])
            realm.add(application!, update: true)
            
        }
    }
    /**
     * explcitly write local realm records into salesforce
     */
    open func writeToSalesforce(swiftlysalesforce : Salesforce) {
        
    }
    
}


/**
 EventProperties functions allows the storing of custom defined events in realm.
 It is effectively a [string : string], but realm doesnt support this natively --- it has to be an object.
 
 - name: the name of the event. eg: Button tapped
 - value: a descriptive string. eg: Add to cart on clearance items page.
 */
@objcMembers class EventProperties: Object {
    dynamic var name = ""
    dynamic var value = ""
    
}

enum SimplyticsError : Error {
    case configurationError(String)
    case salesforceError(String)
}

