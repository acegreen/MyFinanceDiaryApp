import Foundation
import SwiftData

@Model
final class Account: Codable {

    var id: String { accountId }
    var accountId: String
    var balances: Balances
    var mask: String?
    var name: String
    var officialName: String?
    var type: AccountType
    var subtype: String?
        
    private enum CodingKeys: String, CodingKey {
            case accountId = "account_id"
            case balances
            case mask
            case name
            case officialName = "official_name"
            case type
            case subtype
    }

    init(accountId: String, balances: Balances, mask: String? = nil, name: String, officialName: String? = nil, type: AccountType, subtype: String? = nil) {
        self.accountId = accountId
        self.balances = balances
        self.mask = mask
        self.name = name
        self.officialName = officialName
        self.type = type
        self.subtype = subtype
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        accountId = try container.decode(String.self, forKey: .accountId)
        balances = try container.decode(Balances.self, forKey: .balances)
        mask = try container.decodeIfPresent(String.self, forKey: .mask)
        name = try container.decode(String.self, forKey: .name)
        officialName = try container.decodeIfPresent(String.self, forKey: .officialName)
        type = try container.decode(AccountType.self, forKey: .type)
        subtype = try container.decodeIfPresent(String.self, forKey: .subtype)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(accountId, forKey: .accountId)
        try container.encode(balances, forKey: .balances)
        try container.encodeIfPresent(mask, forKey: .mask)
        try container.encode(name, forKey: .name)
        try container.encodeIfPresent(officialName, forKey: .officialName)
        try container.encode(type, forKey: .type)
        try container.encodeIfPresent(subtype, forKey: .subtype)
    }
}

extension Account {
    enum AccountType: String, Codable, CaseIterable {
        case depository
        case credit
        case investment
        case loan
        case other

        var displayName: String {
            switch self {
            case .depository:
                return "Cash"
            case .credit:
                return "Credit Card"
            case .investment:
                return "Investments"
            case .loan:
                return "Loan"
            case .other:
                return "Property"
            }
        }
    }
}
