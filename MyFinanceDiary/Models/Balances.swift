import Foundation

struct Balances: Codable {
    let available: Double?
    let current: Double
    let limit: Double?
    let isoCurrencyCode: String?
    
    private enum CodingKeys: String, CodingKey {
        case available
        case current
        case limit
        case isoCurrencyCode = "iso_currency_code"
    }

    init(current: Double = 0, available: Double? = nil, limit: Double? = nil, isoCurrencyCode: String? = nil) {
        self.available = available
        self.current = current
        self.limit = limit
        self.isoCurrencyCode = isoCurrencyCode
    }
} 