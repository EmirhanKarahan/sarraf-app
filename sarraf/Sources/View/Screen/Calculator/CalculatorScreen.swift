//
//  CalculatorScreen.swift
//  sarraf
//
//  Created by Emirhan KARAHAN on 9.10.2025.
//

import SwiftUI
import GoogleMobileAds
import FirebaseRemoteConfig

// MARK: - Main Calculator Screen
struct CalculatorScreen: View {
    @RemoteConfigProperty(key: Constants.RemoteConfig.isCalculatorBannerVisible, fallback: false) private var isCalculatorBannerVisible
    private let remoteConfig = RemoteConfig.remoteConfig()
    @Environment(Model.self) var model: Model
    @State private var amountText: String = "1"
    @State private var fromAsset: AssetCode = .gramAltin
    @State private var toAsset: AssetCode = .tl
    @State private var fromAssetCalculationType: CalculationType = .buy
    @State private var toAssetCalculationType: CalculationType = .sell
    
    @FocusState var isInputActive: Bool
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        amountInputSection
                        sourceAndTargetFields
                        resultSection
                    }
                    .padding()
                }
                
                Spacer()
                
                if isCalculatorBannerVisible {
                    let adSize = portraitAnchoredAdaptiveBanner(width: UIScreen.main.bounds.width)
                    BannerViewContainer(adSize)
                        .frame(width: adSize.size.width, height: adSize.size.height)
                }
            }
            .onAppear {
                remoteConfig.addOnConfigUpdateListener { update, error in
                    remoteConfig.activate()
                }
            }
            .onTapGesture {
                isInputActive = false
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
            .navigationTitle("Hesaplayıcı")
            .navigationBarTitleDisplayMode(.large)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.systemGroupedBackground))
        }
    }
    
    private var sourceAndTargetFields: some View {
        VStack(alignment: .leading) {
            Text("Kaynak")
                .font(.headline)
                .foregroundColor(.primary)
            
            ZStack {
                VStack(alignment: .leading) {
                    AssetSelectionView(
                        selectedAsset: $fromAsset,
                        calculationType: $fromAssetCalculationType,
                        title: "Kaynak",
                        icon: "arrow.down.circle.fill"
                    )
                    
                    Text("Hedef")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    
                    AssetSelectionView(
                        selectedAsset: $toAsset,
                        calculationType: $toAssetCalculationType,
                        title: "Hedef",
                        icon: "arrow.up.circle.fill"
                    )
                }
                
                HStack {
                    Spacer()
                    Button(action: {
                        (fromAsset, toAsset) = (toAsset, fromAsset)
                    }, label: {
                        Label("Tersine çevir", systemImage: "arrow.up.arrow.down")
                            .labelStyle(.iconOnly)
                            .padding()
                    })
                    .buttonStyle(CalculatorButtonStyle())
                }
            }
        }
    }
    
    // MARK: - Amount Input Section
    private var amountInputSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Miktar")
                .font(.headline)
                .foregroundColor(.primary)
            
            HStack {
                TextField("Miktar girin", text: $amountText)
                    .keyboardType(.decimalPad)
                    .font(.title2.weight(.medium))
                    .textFieldStyle(.plain)
                    .multilineTextAlignment(.trailing)
                    .focused($isInputActive)
                
                Text(fromAsset.displayName)
                    .font(.subheadline.weight(.medium))
                    .foregroundColor(.secondary)
            }
            .modifier(CalculatorFieldModifier())
        }
        .onTapGesture {
            isInputActive.toggle()
        }
    }
    
    // MARK: - Result Section
    private var resultSection: some View {
        VStack(alignment: .leading) {
            Text("Sonuç")
                .font(.headline)
                .foregroundColor(.primary)
            
            resultCard
        }
    }
    
    // MARK: - Result Card
    private var resultCard: some View {
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack(alignment: .firstTextBaseline) {
                        resultAmountText
                        if isCurrencyOutput {
                            Text(toAsset.standaloneName)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                    
                    if !isCurrencyOutput {
                        Text(toAsset.standaloneName)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
                
                Spacer()
                
                Image(toAsset.displayImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 32)
            }
            
            Divider()
            
            VStack(spacing: 2) {
                HStack {
                    Text("\(fromAsset.standaloneName) \(fromAssetCalculationType.rawValue) fiyatı")
                        .font(.caption2)
                    Spacer()
                    let fromAsset = model.getAssetPrice(asset: fromAsset) ?? .init(code: .tl, buy: 1, sell: 1, low: 1, high: 1, close: 1)
                    let fromPrice = fromAssetCalculationType == .buy ? fromAsset.buy : fromAsset.sell
                    Text(verbatim: .formattedPrice(price: fromPrice, currencyCode: fromAsset.code.currencyCode))
                        .animatedNumber(value: fromPrice)
                }
                HStack {
                    Text("\(toAsset.standaloneName) \(toAssetCalculationType.rawValue) fiyatı")
                        .font(.caption2)
                    Spacer()
                    let toAsset = model.getAssetPrice(asset: toAsset) ?? .init(code: .tl, buy: 1, sell: 1, low: 1, high: 1, close: 1)
                    let toPrice = toAssetCalculationType == .buy ? toAsset.buy : toAsset.sell
                    Text(verbatim: .formattedPrice(price: toPrice, currencyCode: toAsset.code.currencyCode))
                        .animatedNumber(value: toPrice)
                }
            }
            .font(.caption)
            .foregroundStyle(.secondary)
        }
        .modifier(CalculatorFieldModifier())
    }
    
    // MARK: - Result Amount Text
    private var resultAmountText: some View {
        let resultAmount: String =  isCurrencyOutput ? .formattedPrice(price: convertedAmount, hideCurrencySymbol: true) : (String(format: "%.2f", convertedAmount) + " adet")
        
        return Text(verbatim: resultAmount)
            .font(.title.weight(.bold))
            .foregroundColor(.primary)
            .animatedNumber(value: convertedAmount)
    }
    
    // MARK: - Computed Properties
    private var convertedAmount: Double {
        let usdTry = model.getAssetPrice(asset: .usdtry)
        let usdSellPriceInTry = usdTry?.sell ?? 1
        
        let fromAsset = model.getAssetPrice(asset: fromAsset) ?? .init(code: .tl, buy: 1, sell: 1, low: 1, high: 1, close: 1)
        
        let amountValue = AppNumberFormatter.parseAmount(amountText)
        let fromPrice = fromAssetCalculationType == .buy ? fromAsset.buy : fromAsset.sell
        let fromPriceValue = fromAsset.code == .ons ? (fromPrice * usdSellPriceInTry) : fromPrice
        
        let toAsset = model.getAssetPrice(asset: toAsset) ?? .init(code: .tl, buy: 1, sell: 1, low: 1, high: 1, close: 1)
        let toPrice = toAssetCalculationType == .buy ? toAsset.buy : toAsset.sell
        let toPriceValue = toAsset.code == .ons ? (toPrice * usdSellPriceInTry) : toPrice
        let baseAmount = amountValue * fromPriceValue
        return baseAmount / toPriceValue
    }
    
    private var isCurrencyOutput: Bool {
        let currencies: [AssetCode] = [.usdtry, .eurtry, .tl]
        return currencies.contains(toAsset)
    }
    
}
