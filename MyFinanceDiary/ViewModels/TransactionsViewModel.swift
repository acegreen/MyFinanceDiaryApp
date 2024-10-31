import SwiftUI
import SwiftData
import Combine

@MainActor
class TransactionsViewModel: ObservableObject {
    @Published var groupedTransactions: [Date: [Transaction]] = [:]
    @Published var isLoading = false
    @Published var error: Error?
    
    private let transactionsService: TransactionsServiceProtocol
    
    init(transactionsService: TransactionsService, modelContext: ModelContext) {
        self.transactionsService = transactionsService

        // Load transactions immediately upon initialization with default type
        Task {
            try? await loadTransactions(for: .depository)
        }
    }
    
    @objc private func handlePlaidConnection() {
        Task {
            try? await loadTransactions(for: .depository)
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
    
    func groupTransactions(_ transactions: [Transaction]) {
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: transactions) { transaction in
            calendar.startOfDay(for: transaction.date)
        }
        groupedTransactions = grouped
    }
    
    func getFilteredTransactions(for accountType: Account.AccountType) -> [Date: [Transaction]] {
        groupedTransactions.mapValues { transactions in
            transactions.filter { $0.accountType == accountType }
        }.filter { !$0.value.isEmpty }
    }

    func dismissError() {
        error = nil
    }
}
