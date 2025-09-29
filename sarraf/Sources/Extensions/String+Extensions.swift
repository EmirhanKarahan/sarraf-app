//
//  String+Extensions.swift
//  Sarraf
//
//  Created by Emirhan KARAHAN on 5.07.2025.
//

import Foundation

extension String {
    static func formattedPrice(price: Double, currencyCode: CurrencyCode = .tl, maximumFractionDigits: Int = 2) -> String {
        return CurrencyFormatter.formatPrice(price: price, currencyCode: currencyCode, maximumFractionDigits: maximumFractionDigits)
    }
}
