//
//  Simplytics.swift
//  simplytics
//
//  Created by Quinton Wall on 11/21/17.
//

import RealmSwift

@objcMembers
public class Simplytics {
    
    // MARK: Logging
    public class func logEvent(_ event: String, funnel:String?=nil) {
        
    }
    
    public class func logEvent(_ event: String, funnel:String?=nil, withProperties properties: [String: Any]) {
        
    }
    
    public class func logScreen(_ screenName: String, funnel:String?=nil) {
        
    }
    
    public class func logScreen(_ screenName: String, funnel:String?=nil, withProperties properties: [String: Any]) {
       
    }
    
    public class func logError(_ name: String, funnel:String?=nil, message: String?, properties: [String: Any]? = nil, error: Error?) {
    }
    
    /**
     * explcitly write local realm records into salesforce
     */
    public class func write() {
        
    }
    
    
    /**
     * Initialize Simplytics to your salesforce instance
     - Parameters:
     - consumerKey: The consumer key from your Salesforce connected app
     - redirectURL: The success/redirect url from your Salesforce connected app
     - hostname: The hostname of your Salesforce instance

     */
    public class func initialize(consumerKey : String, redirectURL: String, hostname : String) {
        
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
class EventProperties: Object {
    dynamic var name = ""
    dynamic var value = ""
}
