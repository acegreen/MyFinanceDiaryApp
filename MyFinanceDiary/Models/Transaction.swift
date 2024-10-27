import Foundation
import SwiftData

@Model
class Transaction {
    enum TransactionType: String, Codable {
        case credit
        case debit
    }   
    
    var id: UUID
    var date: Date
    var transactionDescription: String
    var amount: Double
    var type: TransactionType
    
    init(date: Date = .now, transactionDescription: String = "", amount: Double = 0.0, type: TransactionType = .debit) {
        self.id = UUID()
        self.date = date
        self.transactionDescription = transactionDescription
        self.amount = amount
        self.type = type
    }
}
