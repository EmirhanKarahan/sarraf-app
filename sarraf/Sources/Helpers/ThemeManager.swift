//
//  ThemeManager.swift
//  Sarraf
//
//  Created by Emirhan KARAHAN on 5.07.2025.
//

import SwiftUI
import Combine

class ThemeManager: ObservableObject {
    @Published var selectedTheme: Theme = .system {
        didSet {
            UserDefaults.standard.set(selectedTheme.rawValue, forKey: "selectedTheme")
        }
    }
    
    init() {
        if let savedTheme = UserDefaults.standard.string(forKey: "selectedTheme"),
           let theme = Theme(rawValue: savedTheme) {
            selectedTheme = theme
        }
    }
    
    var colorScheme: ColorScheme? {
        switch selectedTheme {
        case .system:
            return nil
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }
}

extension ThemeManager {
    enum Theme: String, CaseIterable {
        case system
        case light
        case dark
        
        var displayName: LocalizedStringResource {
            switch self {
            case .system:
                return "Sistem"
            case .light:
                return "Açık"
            case .dark:
                return "Koyu"
            }
        }
    }
}
