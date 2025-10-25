//
//  EasyCalculatorTip.swift
//  sarraf
//
//  Created by Emirhan KARAHAN on 25.10.2025.
//

import SwiftUI
import TipKit

struct EasyCalculatorTip: Tip {
    var title: Text { Text("Hızlı Hesaplama Aracı") }
    var message: Text? { Text("Alış/Satış ücretlerini hızlıca hesaplayın") }
    var rules: [Rule] {
        #Rule(HomeScreen.homeScreenVisitedEvent) { event in
            event.donations.count < 2
        }
    }
}
