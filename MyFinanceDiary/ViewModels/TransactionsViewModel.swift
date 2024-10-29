import SwiftUI
import SwiftData
import Combine

@MainActor
class TransactionsViewModel: ObservableObject {
    @Published var groupedTransactions: [Date: [Transaction]] = [:]
    @Published var isLoading = false
    @Published var error: Error?
    
    private let transactionsService: TransactionsServiceProtocol
    private let plaidService: PlaidService
    
    init(transactionsService: TransactionsServiceProtocol? = nil,
         plaidService: PlaidService = PlaidService(),
         modelContext: ModelContext) {
        self.transactionsService = transactionsService ?? TransactionsService(plaidService: plaidService, modelContext: modelContext)
        self.plaidService = plaidService
        
        // Load transactions immediately upon initialization with default type
        Task {
            try? await loadTransactions(for: .cash)
        }
    }
    
    @objc private func handlePlaidConnection() {
        Task {
            try? await loadTransactions(for: .cash)
        }
    }
    
    func loadTransactions(for accountType: Account.AccountType) async throws {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let allTransactions = try await transactionsService.fetchTransactions()
            
            groupTransactions(allTransactions)
        } catch {
            self.error = error
            throw error
        }
    }
    
    private func groupTransactions(_ transactions: [Transaction]) {
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: transactions) { transaction in
            calendar.startOfDay(for: transaction.date)
        }
        groupedTransactions = grouped
    }
    
    func dismissError() {
        error = nil
    }
    
    func getFilteredTransactions(for accountType: Account.AccountType) -> [Date: [Transaction]] {
        groupedTransactions.mapValues { transactions in
            transactions.filter { $0.accountType == accountType }
        }.filter { !$0.value.isEmpty }
    }
}
