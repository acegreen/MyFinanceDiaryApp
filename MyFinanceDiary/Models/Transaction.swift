import Foundation
import SwiftData

@Model
final class Transaction: Codable {
    var amount: Double
    var date: Date
    var name: String
    var merchantName: String?
    var pending: Bool
    var transactionId: String
    
    var displayName: String {
        merchantName ?? name
    }
    
    var transactionType: TransactionType {
        TransactionType(amount: amount)
    }
    
    enum TransactionType: String, Codable {
        case credit
        case debit
        
        init(amount: Double) {
            self = amount >= 0 ? .credit : .debit
        }
    }
    
    init(amount: Double, date: Date, name: String, merchantName: String? = nil, pending: Bool, transactionId: String) {
        self.amount = amount
        self.date = date
        self.name = name
        self.merchantName = merchantName
        self.pending = pending
        self.transactionId = transactionId
    }
    
    // Codable conformance
    enum CodingKeys: String, CodingKey {
        case amount
        case date
        case name
        case merchantName = "merchant_name"
        case pending
        case transactionId = "transaction_id"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        amount = try container.decode(Double.self, forKey: .amount)
        
        // Convert string date to Date object
        let dateString = try container.decode(String.self, forKey: .date)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let parsedDate = dateFormatter.date(from: dateString) {
            date = parsedDate
        } else {
            date = Date()
        }
        
        name = try container.decode(String.self, forKey: .name)
        merchantName = try container.decodeIfPresent(String.self, forKey: .merchantName)
        pending = try container.decode(Bool.self, forKey: .pending)
        transactionId = try container.decode(String.self, forKey: .transactionId)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(amount, forKey: .amount)
        
        // Convert Date back to string
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: date)
        try container.encode(dateString, forKey: .date)
        
        try container.encode(name, forKey: .name)
        try container.encodeIfPresent(merchantName, forKey: .merchantName)
        try container.encode(pending, forKey: .pending)
        try container.encode(transactionId, forKey: .transactionId)
    }
} 
