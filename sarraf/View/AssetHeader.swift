//
//  AssetHeader.swift
//  Sarraf
//
//  Created by Emirhan KARAHAN on 5.07.2025.
//

import SwiftUI

struct AssetHeader: View {
    @EnvironmentObject private var model: Model
    
    var body: some View {
        if #available(iOS 26.0, *) {
            content.glassEffect()
        } else {
            content.background(.thinMaterial, in: Capsule())
        }
    }
}

extension AssetHeader {
    var content: some View {
        HStack {
            ForEach(model.headerAssetPrices) { assetPrice in
                VStack {
                    Text(assetPrice.code.displayName.localizedUppercase).font(.system(size: 12))
                    Text(verbatim: .formattedPrice(price: assetPrice.sell))
                        .font(.system(size: 18)
                            .weight(.semibold))
                }
                if assetPrice.code != .btc {
                    Spacer()
                }
            }
        }.padding().frame(maxWidth: .infinity)
    }
}

extension AssetHeader {
    func getSalePriceFor(asset: AssetCode) -> Double {
        return model.getAssetPrice(asset: asset)?.sell ?? 0
    }
}

#Preview {
    AssetHeader()
}
