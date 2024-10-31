import Foundation
import SwiftData

@Model
final class Provider: Codable, Identifiable {
    @Attribute(.unique) var requestId: String
    @Relationship(deleteRule: .cascade) var item: Item
    @Relationship(deleteRule: .cascade) var accounts: [Account] = []
    @Relationship(deleteRule: .cascade) var transactions: [Transaction] = []
    var totalTransactions: Int = 0
    var id: String

    init(id: String = UUID().uuidString, requestId: String, item: Item, accounts: [Account] = [], transactions: [Transaction] = [], totalTransactions: Int = 0) {
        self.id = id
        self.requestId = requestId
        self.item = item
        self.accounts = accounts
        self.transactions = transactions
        self.totalTransactions = totalTransactions
    }
    
    private enum CodingKeys: String, CodingKey {
        case requestId
        case item
        case accounts
        case transactions
        case totalTransactions
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = ""
        self.requestId = try container.decode(String.self, forKey: .requestId)
        self.item = try container.decode(Item.self, forKey: .item)
        self.accounts = try container.decode([Account].self, forKey: .accounts)
        self.transactions = try container.decode([Transaction].self, forKey: .transactions)
        self.totalTransactions = try container.decodeIfPresent(Int.self, forKey: .totalTransactions) ?? 0
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .requestId)
        try container.encode(item, forKey: .item)
        try container.encode(accounts, forKey: .accounts)
        try container.encode(transactions, forKey: .transactions)
        try container.encode(totalTransactions, forKey: .totalTransactions)
    }
}
