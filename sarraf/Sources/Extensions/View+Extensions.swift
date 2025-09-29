//
//  View+Extensions.swift
//  sarraf
//
//  Created by Emirhan KARAHAN on 29.09.2025.
//

import SwiftUI

extension View {
    @ViewBuilder
    func animatedNumber(value: Double) -> some View {
        if #available(iOS 17.0, *) {
            self
                .contentTransition(.numericText(value: value))
                .animation(.smooth(duration: 1), value: value)
        } else {
            self
                .animation(.easeInOut(duration: 1), value: value)
        }
    }
}
