import Foundation

protocol TransactionsServiceProtocol {
    func fetchTransactions() async throws -> [Transaction]
}

class TransactionsService: TransactionsServiceProtocol {
    @Published var plaidConnectionStatus: PlaidConnectionStatus = .notConnected
    private let plaidService: PlaidService
    
    init(plaidService: PlaidService = PlaidService()) {
        self.plaidService = plaidService
    }
    
    func fetchTransactions() async throws -> [Transaction] {
        // Check if we have a Plaid connection
        guard let _ = plaidService.getStoredAccessToken() else {
            throw PlaidError.noPlaidConnection
        }
        
        // If we have a connection, fetch transactions
        // This is a mock implementation for now
        return []
    }
}

enum PlaidConnectionStatus {
    case notConnected
    case connected
    case error
}
