//
//  FavoriteListItem.swift
//  sarraf
//
//  Created by Emirhan KARAHAN on 16.10.2025.
//

import SwiftUI

struct FavoriteListItem: View {
    let favoriteAsset: FavoriteAsset
    let assetPrice: AssetPrice
    
    var body: some View {
        VStack(spacing: 0) {
            TableRow(asset: assetPrice)
            VStack(spacing: 10) {
                HStack {
                    Text("Favoriye eklendiğindeki satış fiyatı")
                    HStack {
                        Text(verbatim: .formattedPrice(price: favoriteAsset.assetSellPriceWhenAddedToFavorites,
                                                       currencyCode: favoriteAsset.assetCode.currencyCode))
                        .animatedNumber(value: favoriteAsset.assetSellPriceWhenAddedToFavorites)
                        .font(.system(size: 16)
                        .weight(.semibold))
                    }
                    Spacer()
                }
                Divider()
            }
            .padding(.horizontal)
            .font(.subheadline)
        }
        .listRowInsets(EdgeInsets())
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden, edges: .all)
    }
}

#Preview {
    FavoriteListItem(favoriteAsset: .init(asset: .altin,
                                          assetSellPriceWhenAddedToFavorites: 1243.3, order: 0),
                     assetPrice: .init(code: .altin, buy: 1300, sell: 1400, low: 1250, high: 1350, close: 1299))
}
