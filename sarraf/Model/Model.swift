//
//  DataManager.swift
//  Sarraf
//
//  Created by Emirhan KARAHAN on 25.06.2025.
//

import Foundation
import Combine

final class Model: ObservableObject {
    
    private var webSocketTask: URLSessionWebSocketTask?
    private var cancellables = Set<AnyCancellable>()
    
    private let assetHeaderFields: [AssetCode] = [.usdtry, .eurtry, .altin, .btc]
    private let assetListFields: [AssetCode] = [.ons, .altin, .kulcealtin, .ayar22, .ceyrekYeni, .ceyrekEski, .yarimYeni, .yarimEski, .tamYeni, .tamEski]
    
    @Published var listAssetPrices: [AssetPrice] = []
    @Published var headerAssetPrices: [AssetPrice] = []
    
    func getAssetPrice(asset: AssetCode) -> AssetPrice? {
        let assetPrices: [AssetPrice] = headerAssetPrices + listAssetPrices
        return assetPrices.first(where: { $0.code == asset })
    }
    
    func connect() {
        guard let url = URL(string: "wss://\(Constants.API_URL)") else {
            debugPrint("❌ WebSocket URL geçersiz.")
            return
        }
        
        let session = URLSession(configuration: .default)
        webSocketTask = session.webSocketTask(with: url)
        webSocketTask?.resume()
        
        listen()
    }
    
    private func listen() {
        webSocketTask?.receive { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let message):
                switch message {
                case .data(let data):
                    self.handleIncomingData(data)
                case .string(let text):
                    if let data = text.data(using: .utf8) {
                        self.handleIncomingData(data)
                    }
                @unknown default:
                    debugPrint("⚠️ Bilinmeyen WebSocket mesajı alındı.")
                }
            case .failure(let error):
                debugPrint("❌ WebSocket hatası: \(error)")
            }
            
            // Tekrar dinlemeyi başlat
            self.listen()
        }
    }
    
    private func handleIncomingData(_ data: Data) {
        do {
            let data = try JSONDecoder().decode([AssetPrice].self, from: data)
            DispatchQueue.main.async {
                // Filter and sort listAssetPrices according to assetListFields order
                let filteredListData = data.filter { self.assetListFields.contains($0.code) }
                self.listAssetPrices = filteredListData.sorted { first, second in
                    let firstIndex = self.assetListFields.firstIndex(of: first.code) ?? 0
                    let secondIndex = self.assetListFields.firstIndex(of: second.code) ?? 0
                    return firstIndex < secondIndex
                }
                
                // Filter and sort headerAssetPrices according to assetHeaderFields order
                let filteredHeaderData = data.filter { self.assetHeaderFields.contains($0.code) }
                self.headerAssetPrices = filteredHeaderData.sorted { first, second in
                    let firstIndex = self.assetHeaderFields.firstIndex(of: first.code) ?? Int.max
                    let secondIndex = self.assetHeaderFields.firstIndex(of: second.code) ?? Int.max
                    return firstIndex < secondIndex
                }
            }
        } catch {
            debugPrint("❌ Veri ayrıştırılamadı: \(error)")
        }
    }
    
    func disconnect() {
        webSocketTask?.cancel(with: .goingAway, reason: nil)
    }
}
