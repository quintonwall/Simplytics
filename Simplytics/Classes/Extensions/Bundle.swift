//
//  Bundle.swift
//  Simplytics
//
//  Created by Quinton Wall on 11/26/17.
//

import Foundation

extension Bundle {
    
    var releaseVersionNumber: String? {
        return self.infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
    var buildVersionNumber: String? {
        return self.infoDictionary?["CFBundleVersion"] as? String
    }
}
