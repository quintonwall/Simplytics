//
//  Simplytics.swift
//  simplytics
//
//  Created by Quinton Wall on 11/21/17.
//

import RealmSwift
import Realm
import SwiftlySalesforce
import PromiseKit

@objcMembers
open class Simplytics {
    
    
    /// the mobile app being tracked
    var application : SApplication!
    
    public init() {
    }
    
    // MARK: Logging
   
    /**
     * Log a specifc event.
     * returns a unique id for the event which can be used to time an event duration by calling simplytics.endEvent.
     */
    open func logEvent(_ event: String, funnel:String?="", withProperties properties: [String: String]?=nil) -> String {
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
            realm.create(SEvent.self, value: [uuid, event, Date(), Date(), application, funnel, ep])
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
            
            let appid = generateAppID()
            //check if there is an existing realm object
            let eapp = realm.object(ofType: SApplication.self, forPrimaryKey: appid)
            
            if( eapp == nil) {
                let model :String =  UIDevice().model
                 let salesforceid:String = ""
                 let appname:String = name
                 let appversion:String = Bundle.main.releaseVersionNumber!
                 let buildnumber:String = Bundle.main.buildVersionNumber!
                 let device:String = UIDevice().type.rawValue
                 let id:String = generateAppID()
                 let uuid:String  = UIDevice.current.identifierForVendor!.uuidString
               
                let app = SApplication(value: [id, salesforceid, uuid, device, model, appname, appversion, buildnumber])
                realm.add(app, update: true)
                self.application = app
            } else {
                self.application = eapp
            }
        }
    }
    /**
     * explcitly write local realm records into salesforce
     */
    open func writeToSalesforce(_ salesforce : Salesforce)  {
    
        //Check to see if application has been initialized.
        guard application != nil else {
            print("Write to Salesforce aborted. Application was never created. Did you call logApp?")
            return
        }
      
        //if so, then lets check to see if it exists in salesforce. One record is created per device+app version+build number
        first {
            salesforce.query(soql: "SELECT Id FROM Simplytics_Application__c WHERE Name = '\(application.id)'")
        }.then {
            (result: QueryResult<Record>) -> Promise<String> in // if we get a result, the application has already been logged before.
            if result.records.count == 0 { //this must be a new version/build of the app
                 return salesforce.insert(type: "Simplytics_Application__c", fields: ["Name" : self.application.id, "UUID__c" : self.application.uuid, "Device__c" : self.application.device, "App_Version__c" : self.application.appversion, "App_Build_Number__c" : self.application.buildnumber, "Model__c" : self.application.model, "App_Name__c" : self.application.appname])
            } else { //get the existing sfdcid
                return self.getSalesforceApplicationID()
            }
        }.then { // update the application with the sfdcid,
            sfdcid  -> Promise<Data> in
                let realm = try! Realm()
                try! realm.write {
                    self.application.salesforceid = sfdcid
                    realm.add(self.application, update: true)
                }
            var jsonbody : String = ""
                // then insert events into salesforce
                 try! realm.write {
                    let events = realm.objects(SEvent.self).filter("application.id = '\(self.application.id)'")
                    var ej = "{\"applicationid\" : \"\(self.application.salesforceid)\", \"events\" : ["
                    for e in events {
                         ej.append(e.asJSON()+",")
                    }
                    jsonbody = ej.substring(to: ej.index(before: ej.endIndex))+"]}"
                    //print(jsonbody)
                }
         
            
            return salesforce.apex(method: Resource.HTTPMethod.post, path: "/Simplytics", parameters: ["forApp" : self.application.salesforceid], body: jsonbody.data(using: .utf8), contentType: "application/json")
        }.then { //clear everything ready for next time.
            (result: Data) -> Void in
            let realm = try! Realm()
            try! realm.write {
                realm.delete(realm.objects(EventProperties.self))
                realm.delete(realm.objects(SEvent.self))
                realm.delete(realm.objects(SFunnel.self))
            }
        }.catch {
                error in
                // Handle error...
               // throw SimplyticsError.salesforceError(error.localizedDescription)
            print(error)
              print("SIMPLYTICS problem writing to Salesforce \(error)")
        }
    }
    
    
    private func generateAppID() -> String {
        return "\(UIDevice.current.identifierForVendor!.uuidString)-v\(Bundle.main.releaseVersionNumber!)-b\(Bundle.main.buildVersionNumber!)"
    }
    private func getSalesforceApplicationID() -> Promise<String> {
    
        return Promise { fulfill, reject in
            if application == nil {
                reject(SimplyticsError.configurationError("Application was never created. Did you call logApp?"))
            } else {
                fulfill(application.salesforceid)
            }
        }
    }
    
    func getRealmJSON(realmObject: Object, realmType: Any) -> String {
        do {
            let realm = try Realm()
            let table = realm.objects(realmType as! Object.Type)
            if table.count == 0 {return "Empty Table"}
            let mirrored_object = Mirror(reflecting: realmObject)
            var properties = [String]()
            for (_, attr) in mirrored_object.children.enumerated() {
                if let property_name = attr.label as String! {
                    properties.append(property_name)
                }
            }
            var jsonObject = "["
            for i in 1...table.count {
                var str = "{"
                var insideStr = String()
                for property in properties {
                    let filteredTable = table.value(forKey: property) as! [Any]
                    insideStr += "\"\(property)\": \"\(filteredTable[i - 1])\","
                }
                let index = insideStr.characters.index(insideStr.startIndex, offsetBy: (insideStr.count - 2))
                insideStr = String(insideStr[...index])
                str += "\(insideStr)},"
                jsonObject.append(str)
            }
            let index = jsonObject.characters.index(jsonObject.startIndex, offsetBy: (jsonObject.count - 2))
            jsonObject = "\(String(jsonObject[...index]))]"
            return jsonObject
        }catch let error { print("\(error)") }
        return "Problem reading Realm"
    }
}


enum SimplyticsError : Error {
    case configurationError(String)
    case salesforceError(String)
}

