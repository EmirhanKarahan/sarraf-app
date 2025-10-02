//
//  HomeScreen.swift
//  Sarraf
//
//  Created by Emirhan KARAHAN on 5.07.2025.
//

import SwiftUI
import GoogleMobileAds
import FirebaseRemoteConfig

struct HomeScreen: View {
    @EnvironmentObject private var model: Model
    @State private var showingCalculator = false
    private let remoteConfig = RemoteConfig.remoteConfig()
    @RemoteConfigProperty(key: Constants.RemoteConfig.isHomeBannerVisible, fallback: false)
    var isHomeBannerVisible
    
    var body: some View {
        NavigationStack {
            VStack (spacing: 0) {
                ZStack(alignment: .bottomTrailing) {
                    VStack (spacing: 0) {
                        AssetHeader()
                        TableHeader()
                        ScrollView(showsIndicators: false) {
                            VStack(alignment: .leading, spacing: 0) {
                                ForEach(model.listAssetPrices) { asset in
                                    TableRow(asset: asset)
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
                    .padding(.bottom)
                    .popover(isPresented: $showingCalculator, arrowEdge: .bottom) {
                        CalculatorView()
                            .environmentObject(model)
                            .presentationCompactAdaptation(.popover)
                    }
                    
                }.padding(.horizontal)
                
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
            .task {
                model.startFetchingPrices()
            }
            .onAppear {
                remoteConfig.addOnConfigUpdateListener { update, error in
                    remoteConfig.activate()
                }
            }
            .onDisappear {
                model.stopFetchingPrices()
            }
        }
    }
}

struct CalculatorButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        if #available(iOS 26.0, *) {
            configuration.label
                .glassEffect(.regular.interactive())
                .contentShape(Rectangle())
        } else {
            configuration.label
                .background(.thickMaterial)
                .clipShape(.circle)
                .shadow(radius: 4)
                .contentShape(Rectangle())
        }
    }
}

#Preview {
    HomeScreen()
}
