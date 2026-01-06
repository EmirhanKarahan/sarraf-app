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
    let data: [AssetPrice]
    let cached: Bool?
    let cacheAge: Int?
    let lastUpdate: String?
    let error: String?
    let message: String?
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
        didFetchedOnce = true
        Task {
            await fetchPrices()
            startPolling()
        }
    }
    
    private func startPolling() {
        guard pollingTask == nil else { return }
        
        pollingTask = Task {
            do {
                while true {
                    try await Task.sleep(for: .seconds(600))
                    await fetchPrices()
                }
            } catch {
                Logger.log("Polling durduruldu. Error desc: \(error)")
            }
        }
    }

    func stopPolling() {
        pollingTask?.cancel()
        pollingTask = nil
    }
    
    func fetchPrices() async {
        let urlString = "\(Constants.API_URL)/api/prices"
        guard let url = URL(string: urlString) else {
            Logger.error("API URL geçersiz: \(urlString)")
            return
        }
        
        Logger.log("İstek atılıyor: \(urlString)")
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                Logger.error("HTTP response alınamadı")
                return
            }
            
            Logger.log("Yanıt geldi - Status: \(httpResponse.statusCode), Boyut: \(data.count) byte")
            
            guard httpResponse.statusCode == 200 else {
                Logger.error("HTTP hatası: \(httpResponse.statusCode)")
                return
            }
            
            await handleIncomingData(data)
            
        } catch {
            Logger.error("API hatası: \(error.localizedDescription)")
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
            
            Logger.log("Veri başarıyla işlendi - \(apiResponse.data.count) asset alındı")
        } catch {
            Logger.error("Veri ayrıştırılamadı: \(error.localizedDescription)")
        }
    }
}
