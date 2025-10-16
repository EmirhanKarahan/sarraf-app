//
//  HomeScreen.swift
//  Sarraf
//
//  Created by Emirhan KARAHAN on 5.07.2025.
//

import SwiftUI
import GoogleMobileAds
import FirebaseRemoteConfig
import SwiftData

struct HomeScreen: View {
    @Query(sort: \FavoriteAsset.listOrder) var favoriteAssets: [FavoriteAsset] = []
    @Environment(\.modelContext) var modelContext
    
    @Environment(Model.self) var model: Model
    @State private var showingCalculator = false
    @RemoteConfigProperty(key: Constants.RemoteConfig.isHomeBannerVisible, fallback: false) private var isHomeBannerVisible
    private let remoteConfig = RemoteConfig.remoteConfig()
    
    var body: some View {
        NavigationStack {
            VStack (spacing: 0) {
                ZStack(alignment: .bottomTrailing) {
                    VStack (spacing: 0) {
                        AssetHeader()
                            .padding(.horizontal)
                        TableHeader()
                            .padding(.horizontal)
                        ScrollView(showsIndicators: false) {
                            VStack(alignment: .leading, spacing: 0) {
                                ForEach(model.listAssetPrices) { asset in
                                    TableRow(asset: asset)
                                        .contextMenu {
                                            let favoriteAsset = favoriteAssets.first(where: { $0.assetCode == asset.code })
                                            let isFavorite = favoriteAsset != nil
                                            
                                            Button(isFavorite ? "Favorilerden çıkart" : "Favorilere ekle",
                                                   systemImage: isFavorite ? "heart.fill" : "heart",
                                                   action: {
                                                if let favoriteAsset {
                                                    modelContext.delete(favoriteAsset)
                                                } else {
                                                    modelContext.insert(FavoriteAsset(asset: asset.code,
                                                                                      assetSellPriceWhenAddedToFavorites: asset.sell,
                                                                                      order: favoriteAssets.count))
                                                }
                                            })
                                        }
                                }
                                
                                Spacer()
                                    .frame(height: 80)
                            }
                        }
                    }
                    
                    Button(action: {
                        showingCalculator = true
                    }) {
                        Label("Hesaplayıcı", systemImage: "plus.forwardslash.minus")
                            .bold()
                            .labelStyle(.iconOnly)
                            .padding()
                    }
                    .buttonStyle(CalculatorButtonStyle())
                    .padding([.bottom, .trailing])
                    .popover(isPresented: $showingCalculator, arrowEdge: .bottom) {
                        CalculatorView()
                            .environment(model)
                            .presentationCompactAdaptation(.popover)
                    }
                }
                
                if isHomeBannerVisible {
                    let adSize = currentOrientationAnchoredAdaptiveBanner(width: 375)
                    BannerViewContainer(adSize)
                        .frame(width: adSize.size.width, height: adSize.size.height)
                }
            }
            .lineLimit(0)
            .minimumScaleFactor(0.5)
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Kapalı Çarşı")
            .toolbar {
                NavigationLink(destination: SettingsScreen(), label: {
                    Image(systemName: "gear")
                })
            }
            .onAppear {
                remoteConfig.addOnConfigUpdateListener { update, error in
                    remoteConfig.activate()
                }
            }
            .task {
                model.startFetchingPrices()
            }
            .onDisappear {
                model.stopFetchingPrices()
            }
        }
    }
}
