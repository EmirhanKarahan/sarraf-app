//
//  AssetSelectionView.swift
//  sarraf
//
//  Created by Emirhan KARAHAN on 9.10.2025.
//

import SwiftUI

struct AssetSelectionView: View {
    @Binding var selectedAsset: AssetCode
    @Binding var calculationType: CalculationType
    let title: String
    let icon: String
    
    var body: some View {
        Menu {
            Picker("select sell price or buy price", selection: $calculationType) {
                ForEach(CalculationType.allCases) { calculationType in
                    Text(calculationType.rawValue.localizedCapitalized)
                        .tag(calculationType)
                }
            }
            
            ForEach(AssetCode.allCases.reversed(), id: \.rawValue) { code in
                Button {
                    selectedAsset = code
                } label: {
                    HStack {
                        Image(code.displayImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                        Text(code.standaloneName)
                    }
                }
            }
        } label: {
            selectionLabel
        }
    }
    
    // MARK: - Selection Label
    private var selectionLabel: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .font(.title3)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                HStack {
                    Text(selectedAsset.standaloneName)
                        .font(.subheadline.weight(.medium))
                        .foregroundColor(.primary)
                    
                    Text(calculationType.rawValue.localizedCapitalized)
                        .font(.subheadline.weight(.medium))
                        .foregroundColor(.primary)
                        .padding(4)
                        .background(Color(.tertiarySystemGroupedBackground))
                        .cornerRadius(4)
                }
            }
            
            Spacer()
            
            Group {
                Image(selectedAsset.displayImage)
                    .resizable()
                    .scaledToFit()
            }
            .frame(width: 24, height: 24)
            .clipped()
            
            Image(systemName: "chevron.down")
                .foregroundColor(.secondary)
                .font(.caption)
        }
        .modifier(CalculatorFieldModifier())
    }
}
