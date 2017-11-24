//
//  SalesforceDelegate.swift
//  Simplytics_Example
//
//  Created by Quinton Wall on 11/24/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation
import SwiftlySalesforce

public enum SalesforceError: Error {
    case generic(code: Int, message: String)
}

public final class SalesforceDelegate {
    
    public static let shared = SalesforceDelegate()
    
    public fileprivate(set) var contacts: [Contact]?

    public func getContacts() -> Promise<[Contact]> {
        
        return Promise<[Contact]> {
            fulfill, reject in
           
            first {
                salesforce.identity()
                }.then {
                    // Get tasks owned by user
                    userInfo -> Promise<QueryResult<Contact>> in
                    let soql = "SELECT Id, Name FROM Contact ORDER BY CreatedDate DESC"
                    return salesforce.query(soql: soql)
                }.then {
                   (result: QueryResult) -> () in
                    let c = result.records
                    self.contacts = c
                    fulfill(c)
                }.catch {
                    error in
                    reject(error)
            }
        }
    }
}
