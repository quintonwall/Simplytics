//
//  Simplytics.swift
//  simplytics
//
//  Created by Quinton Wall on 11/21/17.
//

import RealmSwift
import SwiftlySalesforce

@objcMembers
open class Simplytics {
    
    //swiftlysalesforce connection
    public var salesforce : Salesforce!
    
    public init(swiftlysalesforce: Salesforce) {
        self.salesforce = swiftlysalesforce
    }
    
    // MARK: Logging
    open func logEvent(_ event: String, funnel:String?=nil) {
        
    }
    
    open func logEvent(_ event: String, funnel:String?=nil, withProperties properties: [String: Any]) {
        
    }
    
    open func logScreen(_ screenName: String, funnel:String?=nil) {
        
    }
    
    open func logScreen(_ screenName: String, funnel:String?=nil, withProperties properties: [String: Any]) {
       
    }
    
    public func logError(_ name: String, funnel:String?=nil, message: String?, properties: [String: Any]? = nil, error: Error?) {
    }
    
    open func logApp(_ name : String) {
        let realm = try! Realm()
        try! realm.write() {
            let model : String =  UIDevice().model
            let appname : String = name
            let appversion: String = Bundle.main.releaseVersionNumber!
            let buildnumber: String = Bundle.main.buildVersionNumber!
            let device: String = UIDevice().type.rawValue
            
           realm.create(SApplication.self, value: [device, model, appname, appversion, buildnumber], update:true)
        }
    }
    /**
     * explcitly write local realm records into salesforce
     */
    open func write() {
        
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
