//
//  FavoriteAsset.swift
//  sarraf
//
//  Created by Emirhan KARAHAN on 15.10.2025.
//

import Foundation
import SwiftData

@Model
class FavoriteAsset {
    var assetCode: AssetCode
    var assetSellPriceWhenAddedToFavorites: Double
    var listOrder: Int
    
    init(asset: AssetCode, assetSellPriceWhenAddedToFavorites: Double, order: Int) {
        self.assetCode = asset
        self.assetSellPriceWhenAddedToFavorites = assetSellPriceWhenAddedToFavorites
        self.listOrder = order
    }
}
