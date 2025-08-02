//
//  String+Extensions.swift
//  Sarraf
//
//  Created by Emirhan KARAHAN on 5.07.2025.
//

import Foundation

enum CurrencyCode: String {
    case tl = "TRY"
    case usd = "USD"
}

extension String {
    
    static func formattedPrice(price: Double, currencyCode: CurrencyCode = .tl, maximumFractionDigits: Int = 2) -> String {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.numberStyle = .currency
        currencyFormatter.locale = Locale.current
        currencyFormatter.currencyCode = currencyCode.rawValue
        
        currencyFormatter.minimumFractionDigits = 0
        currencyFormatter.maximumFractionDigits = maximumFractionDigits
        
        return currencyFormatter.string(from: price as NSNumber)!
    }
    
}
