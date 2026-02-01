//
//  ShimmerModifier.swift
//  sarraf
//
//  Created by Emirhan KARAHAN on 31.01.2026.
//

import SwiftUI

struct ShimmerModifier: ViewModifier {
    @State private var startPoint = UnitPoint(x: -1.8, y: -1.2)
    @State private var endPoint = UnitPoint(x: 0, y: -0.2)
    
    func body(content: Content) -> some View {
        content
            .overlay(
                LinearGradient(
                    colors: [
                        Color.gray.opacity(0.1),
                        Color.white.opacity(0.5),
                        Color.gray.opacity(0.1)
                    ],
                    startPoint: startPoint,
                    endPoint: endPoint
                )
                .mask(content)
                .onAppear {
                    withAnimation(
                        .easeInOut(duration: 1.5)
                        .repeatForever(autoreverses: false)
                    ) {
                        startPoint = UnitPoint(x: 1, y: 1.2)
                        endPoint = UnitPoint(x: 2.2, y: 2.4)
                    }
                }
            )
            .clipped()
    }
}
