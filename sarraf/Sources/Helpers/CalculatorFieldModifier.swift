//
//  CalculatorFieldModifier.swift
//  sarraf
//
//  Created by Emirhan KARAHAN on 11.10.2025.
//

import SwiftUI

struct CalculatorFieldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Color(.secondarySystemGroupedBackground))
            .cornerRadius(20)
    }
}
