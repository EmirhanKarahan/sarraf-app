//
//  TableRow.swift
//  Sarraf
//
//  Created by Emirhan KARAHAN on 5.07.2025.
//

import SwiftUI

struct TableRow: View {
    let index: Int
    let asset: AssetPrice
    
    @StateObject private var viewModel = TableRowViewModel()
    
    var body: some View {
        HStack(spacing: 0) {
            Text("\(index)")
                .frame(width: 20, alignment: .leading)
                .font(.system(size: 14))
            
            HStack(spacing: 8) {
                Image(asset.code.displayImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                
                Text(asset.code.displayName)
                    .font(.system(size: 14))
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(verbatim: .formattedPrice(price: asset.buy, maximumFractionDigits: 0))
                .font(.system(size: 14).weight(.semibold))
                .frame(width: 80, alignment: .trailing)
            
            HStack(spacing: 0) {
                Spacer()
                Text(verbatim: .formattedPrice(price: asset.sell, maximumFractionDigits: 0))
                    .font(.system(size: 14).weight(.semibold))
                    .padding(4)
                    .background(
                        RoundedRectangle(cornerRadius: 4)
                            .fill(viewModel.highlightColor ?? Color.clear)
                            .animation(.easeOut(duration: 0.3), value: viewModel.highlightColor)
                    )
            }.frame(width: 80, alignment: .trailing)
            
            HStack(spacing: 2) {
                differenceImage?.foregroundStyle(differenceColor).font(.system(size: 8))
                Text(asset.differenceString)
                    .font(.system(size: 12))
                    .foregroundColor(differenceColor)
            }
            .frame(width: 70, alignment: .trailing)
        }
        .frame(minHeight: 44)
        .padding(.vertical, 2)
        .onAppear {
            viewModel.update(with: asset.sell)
        }
        .onChange(of: asset.sell) { newSell in
            viewModel.update(with: newSell)
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
