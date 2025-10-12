//
//  CalculatorButtonStyle.swift
//  sarraf
//
//  Created by Emirhan KARAHAN on 10.10.2025.
//

import SwiftUI

struct CalculatorButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        if #available(iOS 26.0, *) {
            configuration.label
                .glassEffect(.regular.interactive())
                .contentShape(Rectangle())
        } else {
            configuration.label
                .background(.thickMaterial)
                .clipShape(.circle)
                .shadow(radius: 4)
                .contentShape(Rectangle())
        }
    }
}
