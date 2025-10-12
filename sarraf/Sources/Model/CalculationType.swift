//
//  CalculationType.swift
//  sarraf
//
//  Created by Emirhan KARAHAN on 12.10.2025.
//

enum CalculationType: String, CaseIterable {
    case buy = "alış"
    case sell = "satış"
}

extension CalculationType: Identifiable {
    var id: String { rawValue }
}
