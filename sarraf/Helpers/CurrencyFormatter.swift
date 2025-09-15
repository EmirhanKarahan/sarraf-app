//
//  CurrencyFormatter.swift
//  sarraf
//
//  Created by Emirhan KARAHAN on 14.09.2025.
//

import Foundation

enum CurrencyCode: String {
    case tl = "TRY"
    case usd = "USD"
}

struct CurrencyFormatter {
    
    static func formatPrice(price: Double, currencyCode: CurrencyCode, maximumFractionDigits: Int) -> String {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.numberStyle = .currency
        currencyFormatter.locale = Locale.current
        currencyFormatter.currencyCode = currencyCode.rawValue
        
        currencyFormatter.minimumFractionDigits = 0
        currencyFormatter.maximumFractionDigits = maximumFractionDigits
        
        return currencyFormatter.string(from: price as NSNumber)!
    }
    
}
