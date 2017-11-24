//
//  Contact.swift
//  Simplytics_Example
//
//  Created by Quinton Wall on 11/24/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation

public final class Contact: Decodable {
    
    public var id: String
    public var name: String?
    
    
    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case name = "Name"
    }
}
