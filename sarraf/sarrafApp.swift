//
//  sarrafApp.swift
//  sarraf
//
//  Created by Emirhan KARAHAN on 20.07.2025.
//

import SwiftUI

@main
struct sarrafApp: App {
    @StateObject private var themeManager = ThemeManager()
    @StateObject private var model = Model()
    
    var body: some Scene {
        WindowGroup {
            HomeScreen()
                .environmentObject(model)
                .environmentObject(themeManager)
                .preferredColorScheme(themeManager.colorScheme)
        }
    }
}
