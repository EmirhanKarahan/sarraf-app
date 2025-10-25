//
//  FavoritesScreen.swift
//  sarraf
//
//  Created by Emirhan KARAHAN on 15.10.2025.
//

import SwiftUI
import SwiftData
import TipKit
import FirebaseRemoteConfig
import GoogleMobileAds

struct FavoritesScreen: View {
    @Query(sort: \FavoriteAsset.order) var favoriteAssets: [FavoriteAsset]
    @Environment(\.modelContext) var modelContext
    @Environment(Model.self) var model: Model
    @RemoteConfigProperty(key: Constants.RemoteConfig.isFavoritesBannerVisible, fallback: false) private var isFavoritesBannerVisible
    private let remoteConfig = RemoteConfig.remoteConfig()
    static let favoritesScreenVisitedEvent = Tips.Event(id: "favoritesScreenVisitedEvent")
    private let editFavoriteTip = EditFavoriteTip()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                TableHeader()
                    .padding(.horizontal)
                
                List {
                    TipView(editFavoriteTip)
                        .tipBackground(Color(.secondarySystemGroupedBackground))
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden, edges: .all)
                    
                    ForEach(favoriteAssets) { favoriteAsset in
                        if let assetPrice = model.getAssetPrice(asset: favoriteAsset.assetCode) {
                            FavoriteListItem(favoriteAsset: favoriteAsset, assetPrice: assetPrice)
                        }
                    }
                    .onDelete(perform: deleteItems)
                    .onMove(perform: moveItems)
                    
                    Spacer()
                        .listRowInsets(EdgeInsets())
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden, edges: .all)
                        .frame(height: 60)
                        .background(Color(.systemGroupedBackground))
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .background(Color.clear)
                
                if isFavoritesBannerVisible {
                    let adSize = portraitAnchoredAdaptiveBanner(width: UIScreen.main.bounds.width)
                    BannerViewContainer(adSize)
                        .frame(width: adSize.size.width, height: adSize.size.height)
                }
            }
            .onAppear {
                setValuesForTips()
                remoteConfig.addOnConfigUpdateListener { update, error in
                    remoteConfig.activate()
                }
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
    
    private func setValuesForTips() {
        if !favoriteAssets.isEmpty {
            Self.favoritesScreenVisitedEvent.sendDonation()
            EditFavoriteTip.favoriteCount = favoriteAssets.count
        }
    }
    
    private func deleteItems(at offsets: IndexSet) {
        editFavoriteTip.invalidate(reason: .actionPerformed)
        for index in offsets {
            modelContext.delete(favoriteAssets[index])
        }
        try? modelContext.save()
    }
    
    private func moveItems(from source: IndexSet, to destination: Int) {
        editFavoriteTip.invalidate(reason: .actionPerformed)
        var revisedItems = favoriteAssets
        revisedItems.move(fromOffsets: source, toOffset: destination)
        
        for (index, item) in revisedItems.enumerated() {
            item.order = index
        }
        try? modelContext.save()
    }
    
}
