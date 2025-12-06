//
//  sarrafApp.swift
//  sarraf
//
//  Created by Emirhan KARAHAN on 20.07.2025.
//

import SwiftUI
import FirebaseCore
import GoogleMobileAds
import SwiftData
import TipKit
@_exported import BugfenderSDK

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        MobileAds.shared.start()
        Bugfender.activateLogger(Constants.BUGFENDER_KEY)
        return true
    }
}

@main
struct sarrafApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var themeManager = ThemeManager()
    @State private var model = Model()
    @State var selectedTab = 0
    
    var body: some Scene {
        WindowGroup {
            TabView(selection: $selectedTab) {
                HomeScreen()
                    .tag(0)
                    .tabItem {
                        Label("Piyasa", systemImage: "tablecells")
                    }
                CalculatorScreen()
                    .tag(1)
                    .tabItem {
                        Label("Hesaplayıcı", systemImage: "x.squareroot")
                    }
                FavoritesScreen()
                    .tag(2)
                    .tabItem {
                        Label("Favoriler", systemImage: "heart")
                    }
            }
            .task {
                try? Tips.configure([
                    .datastoreLocation(.applicationDefault)
                ])
            }
            .environment(model)
            .environmentObject(themeManager)
            .preferredColorScheme(themeManager.colorScheme)
            .modelContainer(for: FavoriteAsset.self)
        }
    }
}
