//
//  Constants.swift
//  Sarraf
//
//  Created by Emirhan KARAHAN on 5.07.2025.
//

import Foundation

struct Constants {
    // MARK: - API Configuration
    static let API_URL = Bundle.main.infoDictionary?["API_URL"] as? String ?? ""
    
    // MARK: - Contact Information
    static let feedbackEmail = "sarraf.app@emirhankarahan.com"

    // MARK: - URLs
    static let privacyPolicyURL = "https://www.notion.so/emirhankarahan/Gizlilik-Politikas-2430a7088fe18042a004e3717cb89c25?source=copy_link"
    static let termsOfServiceURL = "https://www.notion.so/emirhankarahan/Kullan-m-Ko-ullar-2430a7088fe180bfa7edf455bd41625f?source=copy_link"
}
