//
//  NumberFormatter.swift
//  sarraf
//
//  Created by Emirhan KARAHAN on 14.09.2025.
//

import Foundation

struct AppNumberFormatter {
    
    static func getNumberAsPercentString(number: Double, minimumFractionDigits: Int, maximumFractionDigits: Int) -> String {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.numberStyle = .percent
        currencyFormatter.minimumFractionDigits = minimumFractionDigits
        currencyFormatter.maximumFractionDigits = maximumFractionDigits
        return currencyFormatter.string(from: number as NSNumber)!
    }
    
    static func parseAmount(_ text: String) -> Double {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .decimal
        
        if let number = formatter.number(from: text) {
            return number.doubleValue
        }
        
        let cleanedText = text
            .replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: ",", with: ".")
        return Double(cleanedText) ?? 0
    }
    
}
