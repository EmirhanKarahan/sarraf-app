//
//  Bundle+Extensions.swift
//  sarraf
//
//  Created by Emirhan KARAHAN on 2.08.2025.
//

import Foundation

extension Bundle {
    var displayName: String {
        return object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ?? object(forInfoDictionaryKey: "CFBundleName") as? String ?? "Sarraf"
    }
    
    var appVersion: String {
        return object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "1.0.0"
    }
    
    var buildNumber: String {
        return object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "1"
    }
    
    var fullVersion: String {
        return "\(appVersion) (\(buildNumber))"
    }
}
