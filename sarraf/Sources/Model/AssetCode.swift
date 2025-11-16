import SwiftUI

enum AssetCode: String, Codable {
    case tamYeni = "YENI_TAM"
    case tamEski = "ESKI_TAM"
    case yarimYeni = "YENI_YARIM"
    case yarimEski = "ESKI_YARIM"
    case ceyrekYeni = "YENI_CEYREK"
    case ceyrekEski = "ESKI_CEYREK"
    case yeniAta = "YENI_ATA"
    case eskiAta = "ESKI_ATA"
    case ons = "ONS"
    case ayar22 = "22_AYAR"
    case altin = "HAS_ALTIN"
    case gramGumus = "GRAM_GUMUS"
    case gramAltin = "GRAM_ALTIN"
    case eurtry = "EUR_TRY"
    case usdtry = "USD_TRY"
    case tl = "TRY"
}

extension AssetCode: CaseIterable {}
extension AssetCode: Equatable {}

extension AssetCode {
    var currencyCode: CurrencyCode {
        switch self {
        case .ons:
            return .usd
        default:
            return .tl
        }
    }
    
    var displayName: String {
        switch self {
        case .gramAltin:
            return "Gram Altın"
        case .ons:
            return "ONS"
        case .ayar22:
            return "22 Ayar"
        case .altin:
            return "Has Altın"
        case .gramGumus:
            return "Gram Gümüş"
        case .ceyrekYeni:
            return "Yeni Çeyrek"
        case .ceyrekEski:
            return "Eski Çeyrek"
        case .yarimYeni:
            return "Yeni Yarım"
        case .yarimEski:
            return "Eski Yarım"
        case .tamYeni:
            return "Yeni Tam"
        case .tamEski:
            return "Eski Tam"
        case .eurtry:
            return "EUR/TRY"
        case .usdtry:
            return "USD/TRY"
        case .tl:
            return "TRY"
        case .yeniAta:
            return "Yeni Ata"
        case .eskiAta:
            return "Eski Ata"
        }
    }
    
    var standaloneName: String {
        switch self {
        case .usdtry:
            return "USD"
        case .eurtry:
            return "EUR"
        default:
            return displayName
        }
    }
    
    var displayImage: ImageResource {
        switch self {
        case .gramAltin:
            return .gram
        case .ons, .ayar22, .altin:
            return .kulce
        case .gramGumus:
            return .gramGumus
        case .ceyrekYeni, .ceyrekEski:
            return .ceyrek
        case .yarimYeni, .yarimEski:
            return .yarim
        case .tamYeni, .tamEski:
            return .tam
        case .eurtry:
            return .euroSign
        case .usdtry:
            return .dollarSign
        case .tl:
            return .turkishliraSign
        case .yeniAta, .eskiAta:
            return .tam
        }
    }
}

