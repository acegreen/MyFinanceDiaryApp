import Foundation
import SwiftData

@Model
final class Account: Codable {
    var accountId: String
    var balances: Balances?
    var mask: String?
    var name: String
    var officialName: String?
    var persistentAccountId: String?
    var subtype: AccountSubtype
    var type: AccountType
    
    @Relationship(inverse: \Provider.accounts) var provider: Provider?
    
    init(accountId: String = "",
         balances: Balances? = nil,
         mask: String? = nil,
         name: String = "",
         officialName: String? = nil,
         persistentAccountId: String? = nil,
         subtype: AccountSubtype,
         type: AccountType) {
        self.accountId = accountId
        self.balances = balances
        self.mask = mask
        self.name = name
        self.officialName = officialName
        self.persistentAccountId = persistentAccountId
        self.subtype = subtype
        self.type = type
    }
    
    private enum CodingKeys: String, CodingKey {
        case accountId
        case balances
        case mask
        case name
        case officialName
        case persistentAccountId
        case subtype
        case type
    }
    
    convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.init(
            accountId: try container.decode(String.self, forKey: .accountId),
            balances: try container.decode(Balances.self, forKey: .balances),
            mask: try container.decodeIfPresent(String.self, forKey: .mask),
            name: try container.decode(String.self, forKey: .name),
            officialName: try container.decodeIfPresent(String.self, forKey: .officialName),
            persistentAccountId: try container.decodeIfPresent(String.self, forKey: .persistentAccountId),
            subtype: try container.decode(AccountSubtype.self, forKey: .subtype),
            type: try container.decode(AccountType.self, forKey: .type)
        )
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(accountId, forKey: .accountId)
        try container.encode(balances, forKey: .balances)
        try container.encodeIfPresent(mask, forKey: .mask)
        try container.encode(name, forKey: .name)
        try container.encodeIfPresent(officialName, forKey: .officialName)
        try container.encodeIfPresent(persistentAccountId, forKey: .persistentAccountId)
        try container.encodeIfPresent(subtype, forKey: .subtype)
        try container.encode(type, forKey: .type)
    }
}

