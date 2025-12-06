//
//  BannerViewContainer.swift
//  sarraf
//
//  Created by Emirhan KARAHAN on 30.09.2025.
//

import GoogleMobileAds
import SwiftUI

struct BannerViewContainer: UIViewRepresentable {
    typealias UIViewType = BannerView
    let adSize: AdSize

    init(_ adSize: AdSize) {
      self.adSize = adSize
    }
    
    func makeUIView(context: Context) -> BannerView {
        let banner = BannerView(adSize: adSize)
        banner.adUnitID = Constants.GOOGLE_BANNER_UNIT_ID
        banner.load(Request())
        banner.delegate = context.coordinator
        return banner
    }
    
    func updateUIView(_ uiView: BannerView, context: Context) {}
    
    func makeCoordinator() -> BannerCoordinator {
        return BannerCoordinator(self)
    }
    
    class BannerCoordinator: NSObject, BannerViewDelegate {
        
        let parent: BannerViewContainer
        
        init(_ parent: BannerViewContainer) {
            self.parent = parent
        }
        
        // MARK: - GADBannerViewDelegate methods
        func bannerViewDidReceiveAd(_ bannerView: BannerView) {
            Logger.log("Banner reklamı başarıyla yüklendi")
        }
        
        func bannerView(_ bannerView: BannerView, didFailToReceiveAdWithError error: Error) {
            Logger.error("Banner reklamı yüklenemedi: \(error.localizedDescription)")
        }
    }
}
