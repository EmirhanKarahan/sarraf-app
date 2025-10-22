//
//  DataManager.swift
//  Sarraf
//
//  Created by Emirhan KARAHAN on 25.06.2025.
//

import Foundation
import Combine

// MARK: - API Response Models
struct APIResponse: Decodable {
    let meta: APIMeta?
    let data: [AssetPrice]
}

struct APIMeta: Decodable {
    // Add meta fields as needed based on your API response
}

@MainActor @Observable
final class Model {
    
    private var pollingTask: Task<Void, Never>?
    private var didFetchedOnce = false
    
    private let assetHeaderFields: [AssetCode] = [.usdtry, .eurtry, .gramAltin, .gramGumus]
    private let assetListFields: [AssetCode] = [.ons, .altin, .gramAltin, .gramGumus, .ayar22, .ceyrekYeni, .ceyrekEski, .yarimYeni, .yarimEski, .tamYeni, .tamEski]
    
    var listAssetPrices: [AssetPrice] = []
    var headerAssetPrices: [AssetPrice] = []
    
    // Placeholder data for initial display
    private var placeholderListAssets: [AssetPrice] {
        assetListFields.map { code in
            AssetPrice(
                code: code,
                buy: 0,
                sell: 0,
                low: 0,
                high: 0,
                close: 0
            )
        }
    }
    
    private var placeholderHeaderAssets: [AssetPrice] {
        assetHeaderFields.map { code in
            AssetPrice(
                code: code,
                buy: 0,
                sell: 0,
                low: 0,
                high: 0,
                close: 0
            )
        }
    }
    
    init() {
        // Initialize with placeholder data
        listAssetPrices = placeholderListAssets
        headerAssetPrices = placeholderHeaderAssets
    }
    
    func getAssetPrice(asset: AssetCode) -> AssetPrice? {
        let assetPrices: [AssetPrice] = headerAssetPrices + listAssetPrices
        return assetPrices.first(where: { $0.code == asset })
    }
    
    func startFetchingPrices() {
        if didFetchedOnce { return }
        Task {
            await fetchPrices()
            startPolling()
            didFetchedOnce = true
        }
    }
     
    private func startPolling() {
        if pollingTask != nil { return }
        pollingTask = Task {
            while !Task.isCancelled {
                try? await Task.sleep(for: .seconds(5))
                if !Task.isCancelled {
                    await fetchPrices()
                }
            }
        }
    }
    
    func fetchPrices() async {
        guard let url = URL(string: "https://\(Constants.API_URL)/api/prices") else {
            debugPrint("❌ API URL geçersiz.")
            return
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                debugPrint("❌ HTTP hatası: \((response as? HTTPURLResponse)?.statusCode ?? -1)")
                return
            }
            
            await handleIncomingData(data)
            
        } catch {
            debugPrint("❌ API hatası: \(error)")
        }
    }
    
    private func handleIncomingData(_ data: Data) async {
        do {
            let apiResponse = try JSONDecoder().decode(APIResponse.self, from: data)
            
            // Filter and sort listAssetPrices according to assetListFields order
            let filteredListData = apiResponse.data.filter { assetListFields.contains($0.code) }
            listAssetPrices = filteredListData.sorted { first, second in
                let firstIndex = assetListFields.firstIndex(of: first.code) ?? 0
                let secondIndex = assetListFields.firstIndex(of: second.code) ?? 0
                return firstIndex < secondIndex
            }
            
            // Filter and sort headerAssetPrices according to assetHeaderFields order
            let filteredHeaderData = apiResponse.data.filter { assetHeaderFields.contains($0.code) }
            headerAssetPrices = filteredHeaderData.sorted { first, second in
                let firstIndex = assetHeaderFields.firstIndex(of: first.code) ?? Int.max
                let secondIndex = assetHeaderFields.firstIndex(of: second.code) ?? Int.max
                return firstIndex < secondIndex
            }
            
            debugPrint(apiResponse.data)
        } catch {
            debugPrint("❌ Veri ayrıştırılamadı: \(error)")
        }
    }
}
