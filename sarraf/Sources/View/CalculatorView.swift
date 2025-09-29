//
//  CalculatorView.swift
//  Sarraf
//
//  Created by Emirhan KARAHAN on 28.09.2025.
//

import SwiftUI

enum CalculationType: String, CaseIterable {
    case buy = "alış"
    case sell = "satış"
}

struct CalculatorView: View {
    @EnvironmentObject private var model: Model
    @State private var amount: Double = 1
    @State private var selectedAsset: AssetCode = .gramAltin
    @State private var selectedType: CalculationType = .sell
    
    private var totalPrice: Double {
        guard let assetPrice = model.getAssetPrice(asset: selectedAsset) else {
            return 0
        }
        
        let price = selectedType == .buy ? assetPrice.buy : assetPrice.sell
        return amount * price
    }
    
    var body: some View {
        VStack {
            HStack {
                Picker("Miktar", selection: $amount) {
                    ForEach(1...100, id: \.self) { number in
                        Text("\(number)")
                            .tag(Double(number))
                            .padding(8)
                    }
                }
                
                Menu {
                    ForEach(AssetCode.allCases, id: \.hashValue) { code in
                        Button(code.displayName) {
                            selectedAsset = code
                        }
                    }
                } label: {
                    Text(selectedAsset.displayName.localizedLowercase)
                        .padding(8)
                }.fixedSize()
                
            }.fixedSize()
            
            HStack {
                Menu {
                    ForEach(CalculationType.allCases, id: \.self) { type in
                        Button(type.rawValue) {
                            selectedType = type
                        }
                    }
                } label: {
                    Text(selectedType.rawValue)
                        .padding(8)
                }
                
                Text("fiyatı")
                
                Text(verbatim: .formattedPrice(price: totalPrice, currencyCode: selectedAsset.currencyCode))
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
    }
}
