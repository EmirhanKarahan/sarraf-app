enum AssetCode: String, Decodable {
    case kulcealtin = "GRAM_ALTIN"
    case ons = "ONS"
    case ayar22 = "22_AYAR"
    case altin = "HAS_ALTIN"
    case ceyrekYeni = "YENI_CEYREK"
    case ceyrekEski = "ESKI_CEYREK"
    case yarimYeni = "YENI_YARIM"
    case yarimEski = "ESKI_YARIM"
    case tamYeni = "YENI_TAM"
    case tamEski = "ESKI_TAM"
    case eurtry = "EUR_TRY"
    case usdtry = "USD_TRY"
    case btc = "BITCOIN"
}

extension AssetCode {
    var displayName: String {
        switch self {
        case .kulcealtin:
            return "Gram Altın"
        case .ons:
            return "ONS"
        case .ayar22:
            return "22 Ayar"
        case .altin:
            return "Has Altın"
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
            return "EUR TRY"
        case .usdtry:
            return "USD TRY"
        case .btc:
            return "BTC"
        }
    }
    
    var displayImage: ImageResource {
        switch self {
        case .kulcealtin:
            return .gram
        case .ons:
            return .kulce
        case .ayar22:
            return .kulce
        case .altin:
            return .kulce
        case .ceyrekYeni:
            return .ceyrek
        case .ceyrekEski:
            return .ceyrek
        case .yarimYeni:
            return .yarim
        case .yarimEski:
            return .yarim
        case .tamYeni:
            return .tam
        case .tamEski:
            return .tam
        case .eurtry:
            return .kulce
        case .usdtry:
            return .kulce
        case .btc:
            return .kulce
        }
    }
}

