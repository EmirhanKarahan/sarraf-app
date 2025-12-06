//
//  Logger.swift
//  sarraf
//
//  Created by Emirhan KARAHAN on 16.11.2025.
//

struct Logger {
    
    static func log(_ message: String) {
        Bugfender.print(message)
    }
    
    static func warning(_ message: String) {
        Bugfender.warning(message)
    }
    
    static func error(_ message: String) {
        Bugfender.error(message)
    }
}
