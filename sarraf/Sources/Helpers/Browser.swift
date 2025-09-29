//
//  Browser.swift
//  sarraf
//
//  Created by Emirhan KARAHAN on 3.08.2025.
//

import SwiftUI
import SafariServices

struct Browser: UIViewControllerRepresentable {
    let url: URL
    
    func makeUIViewController(context: Context) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {}
}
