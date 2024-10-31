import Foundation

enum AccountType: String, Codable, CaseIterable {
    case depository
    case credit
    case loan
    case investment
    case unknown

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)
        self = AccountType(rawValue: rawValue) ?? .unknown
    }
}

enum AccountSubtype: String, Codable, CaseIterable {
    case checking
    case savings
    case cd
    case creditCard = "credit card"
    case moneyMarket = "money market"
    case ira
    case k401 = "401k"
    case student
    case mortgage
    case hsa
    case cashManagement
    case businessCreditCard
    case unknown

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)
        self = AccountSubtype(rawValue: rawValue) ?? .unknown
    }
}
