//
//  ContextMenuForAsset.swift
//  sarraf
//
//  Created by Emirhan KARAHAN on 16.10.2025.
//

import SwiftUI
import SwiftData

struct ContextMenuForAsset: View {
    @Query var favoriteAssets: [FavoriteAsset] = []
    @Environment(\.modelContext) var modelContext
    let asset: AssetPrice
    
    var body: some View {
        let favoriteAsset = favoriteAssets.first(where: { $0.assetCode == asset.code })
        let isFavorite = favoriteAsset != nil
        
        Text(asset.code.displayName)
        Button(isFavorite ? "Favorilerden çıkart" : "Favorilere ekle",
               systemImage: isFavorite ? "heart.fill" : "heart") {
            if let favoriteAsset {
                modelContext.delete(favoriteAsset)
            } else {
                modelContext.insert(FavoriteAsset(
                    asset: asset.code,
                    assetSellPriceWhenAddedToFavorites: asset.sell,
                    order: favoriteAssets.count
                ))
            }
        }
    }
}
