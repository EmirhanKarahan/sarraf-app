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
import TipKit

struct HomeScreen: View {
    @Environment(Model.self) var model: Model
    @State private var showingCalculator = false
    @RemoteConfigProperty(key: Constants.RemoteConfig.isHomeBannerVisible, fallback: false) private var isHomeBannerVisible
    private let remoteConfig = RemoteConfig.remoteConfig()
    private let addToFavoriteTip = AddToFavoriteTip()
    private let easyCalculatorTip = EasyCalculatorTip()
    static let homeScreenVisitedEvent = Tips.Event(id: "homeScreenVisitedEvent")
    
    var body: some View {
        NavigationStack {
            VStack (spacing: 0) {
                ZStack(alignment: .bottomTrailing) {
                    VStack (spacing: 0) {
                        AssetHeader()
                            .padding(.horizontal)
                        TableHeader()
                            .padding(.horizontal)
                        List {
                            TipView(addToFavoriteTip)
                                .tipBackground(Color(.secondarySystemGroupedBackground))
                                .listRowBackground(Color.clear)
                                .listRowSeparator(.hidden, edges: .all)
                            
                            ForEach(model.listAssetPrices) { asset in
                                TableRow(asset: asset)
                                    .listRowInsets(EdgeInsets())
                                    .listRowBackground(Color.clear)
                                    .listRowSeparator(.hidden, edges: .all)
                                    .contextMenu {
                                        ContextMenuForAsset(asset: asset)
                                    }
                            }
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
                    }
                    
                    Button(action: {
                        showingCalculator = true
                    }) {
                        Label("Hesaplayıcı", systemImage: "plus.forwardslash.minus")
                            .bold()
                            .labelStyle(.iconOnly)
                            .padding()
                    }
                    .popoverTip(easyCalculatorTip)
                    .popover(isPresented: $showingCalculator, arrowEdge: .bottom) {
                        CalculatorView()
                            .environment(model)
                            .presentationCompactAdaptation(.popover)
                            .onAppear {
                                easyCalculatorTip.invalidate(reason: .actionPerformed)
                            }
                    }
                    .buttonStyle(CalculatorButtonStyle())
                    .padding([.bottom, .trailing])
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
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                NavigationLink(destination: SettingsScreen(), label: {
                    Image(systemName: "gear")
                })
            }
            .onAppear {
                Self.homeScreenVisitedEvent.sendDonation()
                remoteConfig.addOnConfigUpdateListener { update, error in
                    remoteConfig.activate()
                }
            }
            .onDisappear {
                easyCalculatorTip.invalidate(reason: .actionPerformed)
            }
            .task {
                model.startFetchingPrices()
            }
        }
    }
}
