//
//  FavoritesScreen.swift
//  sarraf
//
//  Created by Emirhan KARAHAN on 15.10.2025.
//

import SwiftUI
import SwiftData

struct FavoritesScreen: View {
    @Query(sort: \FavoriteAsset.listOrder) var favoriteAssets: [FavoriteAsset] = []
    @Environment(\.modelContext) var modelContext
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(favoriteAssets) { favoriteAsset in
                    Text(favoriteAsset.assetCode.displayName)
                }
                .onDelete(perform: deleteFavorites)
            }
            .overlay {
                if favoriteAssets.isEmpty {
                    ContentUnavailableView {
                        Label("Hiç favoriniz yok", systemImage: "heart")
                    } description: {
                        Text("Favori eklemek için emtia listesindeki ürünlere basılı tutun.")
                    }
                }
            }
            .navigationTitle("Favoriler")
            .navigationBarTitleDisplayMode(.large)
            .background(Color(.systemGroupedBackground))
        }
    }
}

extension FavoritesScreen {
    
    private func deleteFavorites(_ indexSet: IndexSet) {
        for index in indexSet {
            let favorite = favoriteAssets[index]
            modelContext.delete(favorite)
        }
    }
    
}
