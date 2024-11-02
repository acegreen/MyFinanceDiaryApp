import SwiftUI
import SwiftData

@MainActor
class TransactionsViewModel: ObservableObject {
    @Published var groupedTransactions: [Date: [Transaction]]?
    @Published var isLoading = false
    @Published var error: Error?
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func loadTransactions(for accountTypes: [AccountType]) throws {
        self.isLoading = true
        
        let descriptor = FetchDescriptor<Transaction>()
        let transactions = try modelContext.fetch(descriptor)
        
        if !transactions.isEmpty {
            let uniqueTransactions = removeDuplicates(from: transactions)

            let filteredTransactions = uniqueTransactions.filter { transaction in
                guard let provider = transaction.provider else {
                    return false
                }
                let providerAccounts = provider.accounts.filter { accountTypes.contains($0.type) }
                return providerAccounts.map { $0.accountId }.contains(transaction.accountId)
            }
            
            // Sort filtered transactions by date (newest first)
            groupTransactions(filteredTransactions)
        }
        
        self.isLoading = false
    }
    
    private func removeDuplicates(from transactions: [Transaction]) -> [Transaction] {
        let uniqueTransactions = Dictionary(grouping: transactions) { $0.transactionId }
            .compactMapValues { $0.first }
            .values
        return Array(uniqueTransactions)
    }
    
    func groupTransactions(_ transactions: [Transaction]) {
        let calendar = Calendar.current
        var grouped = Dictionary(grouping: transactions) { calendar.startOfDay(for: $0.date) }
        
        // Sort transactions within each day group by date first, then by name
        for (date, transactions) in grouped {
            grouped[date] = transactions.sorted { t1, t2 in
                if t1.date == t2.date {
                    return t1.name < t2.name // alphabetical order when dates are equal
                }
                return t1.date > t2.date // newest first
            }
        }
        
        groupedTransactions = grouped
    }
}
