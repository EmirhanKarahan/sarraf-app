//
//  Logger.swift
//  sarraf
//
//  Created by Emirhan KARAHAN on 16.11.2025.
//

import Foundation
import os.log

enum LogLevel: String {
    case debug = "🔍 DEBUG"
    case info = "ℹ️ INFO"
    case warning = "⚠️ WARNING"
    case error = "❌ ERROR"
    case network = "🌐 NETWORK"
    case success = "✅ SUCCESS"
}

struct Logger {
    
    // MARK: - Properties
    private static let subsystem = Bundle.main.bundleIdentifier ?? "com.sarraf"
    private static let osLog = OSLog(subsystem: subsystem, category: "general")
    
    // MARK: - Debug Check
    private static var isDebugMode: Bool {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }
    
    // MARK: - Basic Logging
    static func log(
        _ message: String,
        level: LogLevel = .info,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        guard isDebugMode else { return }
        
        let fileName = (file as NSString).lastPathComponent
        let timestamp = dateFormatter.string(from: Date())
        
        let logMessage = """
        
        [\(timestamp)] \(level.rawValue)
        📍 \(fileName) → \(function):\(line)
        💬 \(message)
        ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
        """
        
        print(logMessage)
    }
    
    // MARK: - Level-specific Logging
    static func debug(
        _ message: String,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        log(message, level: .debug, file: file, function: function, line: line)
    }
    
    static func info(
        _ message: String,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        log(message, level: .info, file: file, function: function, line: line)
    }
    
    static func warning(
        _ message: String,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        log(message, level: .warning, file: file, function: function, line: line)
    }
    
    static func error(
        _ message: String,
        error: Error? = nil,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        var errorMessage = message
        if let error = error {
            errorMessage += "\n⚠️ Error Details: \(error.localizedDescription)"
        }
        log(errorMessage, level: .error, file: file, function: function, line: line)
    }
    
    static func success(
        _ message: String,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        log(message, level: .success, file: file, function: function, line: line)
    }
    
    // MARK: - Network Logging
    static func logAPIRequest(
        url: String,
        method: String = "GET",
        headers: [String: String]? = nil,
        body: Data? = nil,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        guard isDebugMode else { return }
        
        let fileName = (file as NSString).lastPathComponent
        let timestamp = dateFormatter.string(from: Date())
        
        var logMessage = """
        
        [\(timestamp)] 🌐 API REQUEST
        📍 \(fileName) → \(function):\(line)
        🔗 \(method) \(url)
        """
        
        if let headers = headers, !headers.isEmpty {
            logMessage += "\n📋 Headers:\n\(prettyPrint(dictionary: headers))"
        }
        
        if let body = body, let jsonString = prettyPrintJSON(data: body) {
            logMessage += "\n📦 Body:\n\(jsonString)"
        }
        
        logMessage += "\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        
        print(logMessage)
    }
    
    static func logAPIResponse(
        url: String,
        statusCode: Int? = nil,
        headers: [AnyHashable: Any]? = nil,
        data: Data? = nil,
        error: Error? = nil,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        guard isDebugMode else { return }
        
        let fileName = (file as NSString).lastPathComponent
        let timestamp = dateFormatter.string(from: Date())
        
        let statusEmoji = statusEmoji(for: statusCode)
        
        var logMessage = """
        
        [\(timestamp)] 🌐 API RESPONSE
        📍 \(fileName) → \(function):\(line)
        🔗 \(url)
        """
        
        if let statusCode = statusCode {
            logMessage += "\n\(statusEmoji) Status: \(statusCode)"
        }
        
        if let error = error {
            logMessage += "\n❌ Error: \(error.localizedDescription)"
        }
        
        if let headers = headers as? [String: Any], !headers.isEmpty {
            logMessage += "\n📋 Headers:\n\(prettyPrint(dictionary: headers))"
        }
        
        if let data = data {
            if let jsonString = prettyPrintJSON(data: data) {
                logMessage += "\n📦 Response Body:\n\(jsonString)"
            } else if let stringData = String(data: data, encoding: .utf8) {
                logMessage += "\n📦 Response Body:\n\(stringData)"
            }
        }
        
        logMessage += "\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        
        print(logMessage)
    }
    
    // MARK: - JSON Pretty Printing
    static func logJSON(_ data: Data, title: String = "JSON Data") {
        guard isDebugMode else { return }
        
        if let jsonString = prettyPrintJSON(data: data) {
            print("""
            
            ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
            📄 \(title)
            \(jsonString)
            ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
            """)
        }
    }
    
    static func logJSON(_ object: Any, title: String = "JSON Object") {
        guard isDebugMode else { return }
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: object, options: .prettyPrinted)
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print("""
                
                ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
                📄 \(title)
                \(jsonString)
                ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
                """)
            }
        } catch {
            Logger.error("Failed to serialize JSON: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Helper Methods
    private static func prettyPrintJSON(data: Data) -> String? {
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            let prettyData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            return String(data: prettyData, encoding: .utf8)
        } catch {
            return String(data: data, encoding: .utf8)
        }
    }
    
    private static func prettyPrint<T>(dictionary: [String: T]) -> String {
        let sorted = dictionary.sorted { $0.key < $1.key }
        return sorted.map { "  \($0.key): \($0.value)" }.joined(separator: "\n")
    }
    
    private static func statusEmoji(for statusCode: Int?) -> String {
        guard let code = statusCode else { return "❓" }
        
        switch code {
        case 200..<300:
            return "✅"
        case 300..<400:
            return "↪️"
        case 400..<500:
            return "⚠️"
        case 500..<600:
            return "❌"
        default:
            return "❓"
        }
    }
    
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss.SSS"
        return formatter
    }()
}

// MARK: - Extension for Encodable Objects
extension Logger {
    static func logEncodable<T: Encodable>(_ object: T, title: String = "Encodable Object") {
        guard isDebugMode else { return }
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        do {
            let jsonData = try encoder.encode(object)
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print("""
                
                ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
                📄 \(title)
                \(jsonString)
                ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
                """)
            }
        } catch {
            Logger.error("Failed to encode object: \(error.localizedDescription)")
        }
    }
}
