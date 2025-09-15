//
//  AssetPrice.swift
//  Sarraf
//
//  Created by Emirhan KARAHAN on 3.07.2025.
//

import SwiftUI

struct AssetPrice: Decodable {
    let code: AssetCode
    let buy: Double
    let sell: Double
    let low: Double
    let high: Double
    let close: Double
    
    var difference: Double {
        let diff = ((sell - close) / close)
        return diff
    }
    
    var differenceString: String {
        let difference = abs(difference)
        return AppNumberFormatter.getNumberAsPercentString(number: difference, minimumFractionDigits: 2, maximumFractionDigits: 2)
    }
    
}

extension AssetPrice: Identifiable {
    var id: String { code.rawValue }
}

extension AssetPrice: Equatable {}

extension AssetPrice {
    var isPlaceholder: Bool {
        return buy == 0 && sell == 0 && low == 0 && high == 0 && close == 0
    }
}
