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
        currencyFormatter.locale = Locale.current
        
        currencyFormatter.minimumFractionDigits = minimumFractionDigits
        currencyFormatter.maximumFractionDigits = maximumFractionDigits
        
        return currencyFormatter.string(from: number as NSNumber)!
    }
    
}
