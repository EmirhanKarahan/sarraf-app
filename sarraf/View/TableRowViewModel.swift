//
//  TableRowViewModel.swift
//  Sarraf
//
//  Created by Emirhan KARAHAN on 15.07.2025.
//

import SwiftUI
import Combine

final class TableRowViewModel: ObservableObject {
    @Published var highlightColor: Color? = nil

    private var previousSell: Double?
    private var cancellable: AnyCancellable?

    func update(with newSell: Double) {
        if let previous = previousSell {
            if newSell > previous {
                triggerHighlight(.green.opacity(0.4))
            } else if newSell < previous {
                triggerHighlight(.red.opacity(0.4))
            }
        }
        previousSell = newSell
    }

    private func triggerHighlight(_ color: Color) {
        highlightColor = color
        // 0.3 saniye sonra rengi sıfırla
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation(.easeOut(duration: 0.4)) {
                self.highlightColor = nil
            }
        }
    }
}
