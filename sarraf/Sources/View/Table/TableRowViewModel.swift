//
//  TableRowViewModel.swift
//  Sarraf
//
//  Created by Emirhan KARAHAN on 15.07.2025.
//

import SwiftUI
import Combine

final class TableRowViewModel: ObservableObject {
    @Published var buyHighlightColor: Color? = nil
    @Published var sellHighlightColor: Color? = nil

    private var previousBuy: Double?
    private var previousSell: Double?
    private var cancellable: AnyCancellable?

    func update(with newBuy: Double, newSell: Double) {
        // Check buy price change
        if let previous = previousBuy {
            if newBuy > previous {
                triggerBuyHighlight(.green.opacity(0.4))
            } else if newBuy < previous {
                triggerBuyHighlight(.red.opacity(0.4))
            }
        }
        previousBuy = newBuy
        
        // Check sell price change
        if let previous = previousSell {
            if newSell > previous {
                triggerSellHighlight(.green.opacity(0.4))
            } else if newSell < previous {
                triggerSellHighlight(.red.opacity(0.4))
            }
        }
        previousSell = newSell
    }

    private func triggerBuyHighlight(_ color: Color) {
        buyHighlightColor = color
        // 0.3 saniye sonra rengi sıfırla
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            withAnimation(.easeOut(duration: 0.7)) {
                self.buyHighlightColor = nil
            }
        }
    }
    
    private func triggerSellHighlight(_ color: Color) {
        sellHighlightColor = color
        // 0.3 saniye sonra rengi sıfırla
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            withAnimation(.easeOut(duration: 0.7)) {
                self.sellHighlightColor = nil
            }
        }
    }
}
