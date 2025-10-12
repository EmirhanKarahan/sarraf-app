//
//  AssetMenu.swift
//  sarraf
//
//  Created by Emirhan KARAHAN on 12.10.2025.
//

import SwiftUI

struct AssetMenu: View {
    @Binding var selectedAsset: AssetCode
    
    var body: some View {
        Menu {
            ForEach(AssetCode.allCases.reversed(), id: \.rawValue) { code in
                Button(code.displayName) {
                    selectedAsset = code
                }
            }
        } label: {
            Text(selectedAsset.displayName.localizedLowercase)
                .padding(8)
        }
        .fixedSize()
    }
}
