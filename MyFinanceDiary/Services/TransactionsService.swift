import Foundation
import SwiftData
import SwiftUI

protocol TransactionsServiceProtocol {
    func fetchTransactions() async throws -> [Transaction]
}

class TransactionsService: TransactionsServiceProtocol {
    private let plaidService: PlaidService
    private let modelContext: ModelContext
    
    init(plaidService: PlaidService = PlaidService(), modelContext: ModelContext) {
        self.plaidService = plaidService
        self.modelContext = modelContext
    }
    
    func fetchTransactions() async throws -> [Transaction] {
        guard let accessToken = plaidService.getStoredAccessToken() else {
            throw PlaidError.noPlaidConnection
        }
        
        // Create date formatter
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        // For testing, return mock data
        let mockPlaidTransactions = [
            Transaction(
                amount: -12.99,  // negative for debit transactions
                date: dateFormatter.date(from: "2024-03-20") ?? Date(),
                name: "Starbucks Coffee",
                merchantName: "Starbucks",
                pending: false,
                transactionId: "tx_1"
            ),
            Transaction(
                amount: -45.50,  // negative for debit transactions
                date: dateFormatter.date(from: "2024-03-19") ?? Date(),
                name: "Amazon.com",
                merchantName: "Amazon",
                pending: false,
                transactionId: "tx_2"
            )
        ]
        
        // Save to SwiftData
        for transaction in mockPlaidTransactions {
            modelContext.insert(transaction)
        }
        
        try modelContext.save()
        return mockPlaidTransactions
    }
}

enum PlaidConnectionStatus {
    case notConnected
    case connected
    case error
}
