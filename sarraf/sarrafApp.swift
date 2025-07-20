//
//  sarrafApp.swift
//  sarraf
//
//  Created by Emirhan KARAHAN on 20.07.2025.
//

import SwiftUI

@main
struct sarrafApp: App {
    var body: some Scene {
        WindowGroup {
            HomeScreen().environmentObject(Model())
        }
    }
}
