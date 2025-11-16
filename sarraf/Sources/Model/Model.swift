//
//  DataManager.swift
//  Sarraf
//
//  Created by Emirhan KARAHAN on 25.06.2025.
//

import Foundation
import Combine

// MARK: - API Response Models
struct APIResponse: Codable {
    let meta: APIMeta?
    let data: [AssetPrice]
}

struct APIMeta: Codable {
    let cached: Bool?
    let cacheAge: Int?
    let lastUpdate: String?
    let stale: Bool?
    let error: String?
}

@MainActor @Observable
final class Model {
    
    private var pollingTask: Task<Void, Never>?
    private var didFetchedOnce = false
    
    private let assetHeaderFields: [AssetCode] = [.usdtry, .eurtry, .gramAltin, .gramGumus]
    private let assetListFields: [AssetCode] = [.ons, .altin, .gramAltin, .gramGumus, .ayar22, .ceyrekYeni, .ceyrekEski, .yarimYeni, .yarimEski, .tamYeni, .tamEski, .yeniAta, .eskiAta]
    
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
        let urlString = "http://\(Constants.API_URL)/api/prices"
        guard let url = URL(string: urlString) else {
            Logger.error("API URL geçersiz: \(urlString)")
            return
        }
        
        Logger.logAPIRequest(url: urlString, method: "GET")
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
                Logger.logAPIResponse(
                    url: urlString,
                    statusCode: statusCode,
                    data: nil,
                    error: nil
                )
                Logger.error("HTTP hatası: \(statusCode)")
                return
            }
            
            Logger.logAPIResponse(
                url: urlString,
                statusCode: httpResponse.statusCode,
                headers: httpResponse.allHeaderFields,
                data: data
            )
            
            await handleIncomingData(data)
            
        } catch {
            Logger.logAPIResponse(
                url: urlString,
                statusCode: nil,
                data: nil,
                error: error
            )
            Logger.error("API hatası", error: error)
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
        } catch {
            Logger.error("Veri ayrıştırılamadı", error: error)
        }
    }
}
