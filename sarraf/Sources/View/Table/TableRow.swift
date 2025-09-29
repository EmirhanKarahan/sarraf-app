//
//  TableRow.swift
//  Sarraf
//
//  Created by Emirhan KARAHAN on 5.07.2025.
//

import SwiftUI

struct TableRow: View {
    let asset: AssetPrice
    
    @StateObject private var viewModel = TableRowViewModel()
    
    var body: some View {
        HStack(spacing: 0) {
            HStack(spacing: 8) {
                Image(asset.code.displayImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 28, height: 28)
                
                Text(asset.code.displayName)
                    .font(.system(size: 16))
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(spacing: 0) {
                Spacer()
                Text(asset.isPlaceholder ? "-" : .formattedPrice(price: asset.buy,
                                                                 currencyCode: asset.code.currencyCode,
                                                                 maximumFractionDigits: asset.code == .gramGumus ? 2 : 0))
                    .font(.system(size: 16).weight(.semibold))
                    .padding(4)
                    .background(
                        RoundedRectangle(cornerRadius: 4)
                            .fill(viewModel.buyHighlightColor ?? Color.clear)
                            .animation(.easeOut(duration: 0.3), value: viewModel.buyHighlightColor)
                    )
            }.frame(width: 85, alignment: .trailing)
            
            HStack(spacing: 0) {
                Spacer()
                Text(asset.isPlaceholder ? "-" : .formattedPrice(price: asset.sell,
                                                                 currencyCode: asset.code.currencyCode,
                                                                 maximumFractionDigits: asset.code == .gramGumus ? 2 : 0))
                    .font(.system(size: 16).weight(.semibold))
                    .padding(4)
                    .background(
                        RoundedRectangle(cornerRadius: 4)
                            .fill(viewModel.sellHighlightColor ?? Color.clear)
                            .animation(.easeOut(duration: 0.3), value: viewModel.sellHighlightColor)
                    )
            }.frame(width: 85, alignment: .trailing)
            
            HStack(spacing: 2) {
                if !asset.isPlaceholder {
                    differenceImage?.foregroundStyle(differenceColor).font(.system(size: 8))
                }
                Text(asset.isPlaceholder ? "-" : asset.differenceString)
                    .font(.system(size: 14))
                    .foregroundColor(asset.isPlaceholder ? .primary : differenceColor)
            }
            .frame(width: 70, alignment: .trailing)
        }
        .frame(minHeight: 44)
        .padding(.vertical, 2)
        .onAppear {
            viewModel.update(with: asset.buy, newSell: asset.sell)
        }
        .onChange(of: asset.buy) { newBuy in
            viewModel.update(with: newBuy, newSell: asset.sell)
        }
        .onChange(of: asset.sell) { newSell in
            viewModel.update(with: asset.buy, newSell: newSell)
        }
    }
    
    private var differenceColor: Color {
        let diff = asset.difference
        if diff > 0 {
            return .green
        } else if diff < 0 {
            return .red
        } else {
            return .primary
        }
    }
    
    private var differenceImage: Image? {
        let diff = asset.difference
        if diff > 0 {
            return Image(systemName: "arrowtriangle.up.fill")
        } else if diff < 0 {
            return Image(systemName: "arrowtriangle.down.fill")
        } else {
            return nil
        }
    }
}
