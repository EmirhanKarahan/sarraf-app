//
//  FavoritesScreen.swift
//  sarraf
//
//  Created by Emirhan KARAHAN on 15.10.2025.
//

import SwiftUI
import SwiftData

struct FavoritesScreen: View {
    @Query(sort: \FavoriteAsset.order) var favoriteAssets: [FavoriteAsset]
    @Environment(\.modelContext) var modelContext
    @Environment(Model.self) var model: Model
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 0) {
                TableHeader()
                    .padding(.horizontal)
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden, edges: .all)
                
                List {
                    ForEach(favoriteAssets) { favoriteAsset in
                        if let assetPrice = model.getAssetPrice(asset: favoriteAsset.assetCode) {
                            FavoriteListItem(favoriteAsset: favoriteAsset, assetPrice: assetPrice)
                        }
                    }
                    .onDelete(perform: deleteItems)
                    .onMove(perform: moveItems)
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .background(Color.clear)
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
    
    private func deleteItems(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(favoriteAssets[index])
        }
        try? modelContext.save()
    }
    
    private func moveItems(from source: IndexSet, to destination: Int) {
        var revisedItems = favoriteAssets
        revisedItems.move(fromOffsets: source, toOffset: destination)
        
        for (index, item) in revisedItems.enumerated() {
            item.order = index
        }
        try? modelContext.save()
    }
    
}
