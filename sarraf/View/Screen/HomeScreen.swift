//
//  HomeScreen.swift
//  Sarraf
//
//  Created by Emirhan KARAHAN on 5.07.2025.
//

import SwiftUI

struct HomeScreen: View {
    @EnvironmentObject private var model: Model
    
    var body: some View {
        NavigationStack {
            VStack (spacing: 0) {
                AssetHeader()
                TableHeader()
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        ForEach(model.listAssetPrices.indices, id: \.self) { index in
                            let asset = model.listAssetPrices[index]
                            TableRow(index: index + 1, asset: asset)
                        }
                        Spacer()
                    }
                }
            }
            .padding(.horizontal)
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Piyasalar")
            .toolbar {
                NavigationLink(destination: SettingsScreen(), label: {
                    Image(systemName: "gear")
                })
            }
        }
        .task {
            model.connect()
        }
    }
}

#Preview {
    HomeScreen()
}
