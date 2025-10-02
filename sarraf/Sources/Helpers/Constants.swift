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
    static let GOOGLE_BANNER_UNIT_ID = Bundle.main.infoDictionary?["GOOGLE_BANNER_UNIT_ID"] as? String ?? ""
    
    // MARK: - Contact Information
    static let feedbackEmail = "mail@emirhankarahan.com"

    // MARK: - URLs
    static let privacyPolicyURL = "https://www.emirhankarahan.com/apps/sarraf/privacy-policy"
    static let termsOfServiceURL = "https://www.emirhankarahan.com/apps/sarraf/terms-of-use"
}

extension Constants {
    enum RemoteConfig {
       static let isHomeBannerVisible = "IS_HOME_BANNER_VISIBLE"
    }
}
