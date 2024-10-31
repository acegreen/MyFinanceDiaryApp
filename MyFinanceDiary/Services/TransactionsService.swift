import Foundation
import SwiftData
import SwiftUI

protocol TransactionsServiceProtocol {
    func fetchTransactions() async throws -> [Transaction]
}

class TransactionsService: TransactionsServiceProtocol {
    private let plaidService: PlaidService
    private let modelContext: ModelContext
    
    init(plaidService: PlaidService, modelContext: ModelContext) {
        self.plaidService = plaidService
        self.modelContext = modelContext
    }
    
    func fetchTransactions() async throws -> [Transaction] {
        print("📥 Starting transaction fetch")
        
        let endDate = Date()
        let startDate = Calendar.current.date(byAdding: .month, value: -1, to: endDate) ?? endDate
        
        let transactions = try await plaidService.fetchTransactions(startDate: startDate, endDate: endDate)
        print("✅ Fetched \(transactions.count) transactions")
        
        for transaction in transactions {
            modelContext.insert(transaction)
        }
            
        try modelContext.save()
        print("💾 Saved transactions to SwiftData")
        
        return transactions
    }
}

enum PlaidConnectionStatus {
    case notConnected
    case connected
    case error
}
