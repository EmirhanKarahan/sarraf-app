//
//  EditFavoriteTip.swift
//  sarraf
//
//  Created by Emirhan KARAHAN on 25.10.2025.
//

import SwiftUI
import TipKit

struct EditFavoriteTip: Tip {
    @Parameter static var hasEnoughFavoriteToSwipeAndDelete: Bool = false
    var title: Text { Text("Favorileri Silme veya Sıralama") }
    var message: Text? { Text("Favorilerinizi silmek veya sıralamak için sola sürükleyin veya basılı tutun") }
    var image: Image? { Image(systemName: "info.circle") }
    
    var rules: [Rule] {
        #Rule(Self.$hasEnoughFavoriteToSwipeAndDelete) { $0 == true }
    }
}
