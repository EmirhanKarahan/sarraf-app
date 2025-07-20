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
        let diff = ((buy - close) / close) * 100
        return diff
    }
    
    var differenceString: String {
        return String(format: "%.2f%%", abs(difference))
    }
    
}

extension AssetPrice: Identifiable {
    var id: String { code.rawValue }
}

extension AssetPrice: Equatable {}
