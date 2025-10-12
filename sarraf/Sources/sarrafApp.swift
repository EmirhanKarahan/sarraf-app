//
//  sarrafApp.swift
//  sarraf
//
//  Created by Emirhan KARAHAN on 20.07.2025.
//

import SwiftUI
import FirebaseCore
import GoogleMobileAds

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        MobileAds.shared.start()
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
                        Label("Fiyatlar", systemImage: "house")
                    }
                CalculatorScreen()
                    .tag(1)
                    .tabItem {
                        Label("Hesaplayıcı", systemImage: "x.squareroot")
                    }
            }
            .environment(model)
            .environmentObject(themeManager)
            .preferredColorScheme(themeManager.colorScheme)
        }
    }
}
