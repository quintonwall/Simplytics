//
//  Simplytics.swift
//  simplytics
//
//  Created by Quinton Wall on 11/21/17.
//

import RealmSwift
import SwiftlySalesforce

@objcMembers
public class Simplytics {
    
    //swiftlysalesforce connection
    public var salesforce : Salesforce!
    
    // MARK: Logging
    public func logEvent(_ event: String, funnel:String?=nil) {
        
    }
    
    public func logEvent(_ event: String, funnel:String?=nil, withProperties properties: [String: Any]) {
        
    }
    
    public func logScreen(_ screenName: String, funnel:String?=nil) {
        
    }
    
    public func logScreen(_ screenName: String, funnel:String?=nil, withProperties properties: [String: Any]) {
       
    }
    
    public func logError(_ name: String, funnel:String?=nil, message: String?, properties: [String: Any]? = nil, error: Error?) {
    }
    
    /**
     * explcitly write local realm records into salesforce
     */
    public func write() {
        
    }
    
    
    // MARK: lifecycle
    public class func applicationDidLaunch() {
        //just in case the app crashed before we could write records to salesforce, lets do it on app launch
    }
    
    public class func applicationWillEnterForeground() {
        
    }
    
    public class func applicationDidEnterBackground() {
        //write to salesforce and clear realm objects
    }
    
    public class func applicationWillTerminate() {
       //write to salesforce and clear realm objects
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
