//
//  EditFavoriteTip.swift
//  sarraf
//
//  Created by Emirhan KARAHAN on 25.10.2025.
//

import SwiftUI
import TipKit

struct EditFavoriteTip: Tip {
    @Parameter static var favoriteCount: Int = 0
    var title: Text { Text("Favorileri Silme veya Sıralama") }
    var message: Text? { Text("Favorilerinizi silmek veya sıralamak için sola sürükleyin veya basılı tutun") }
    var image: Image? { Image(systemName: "info.circle") }
    
    var rules: [Rule] {
        #Rule(FavoritesScreen.favoritesScreenVisitedEvent) { event in
            event.donations.count > 2
        }
        
        #Rule(Self.$favoriteCount) { $0 > 2 }
    }
}
