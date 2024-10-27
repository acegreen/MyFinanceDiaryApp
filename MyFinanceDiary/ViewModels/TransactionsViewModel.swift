import Foundation

@MainActor
class TransactionsViewModel: ObservableObject {
    @Published private(set) var groupedTransactions: [Date: [Transaction]] = [:]
    @Published private(set) var isLoading = false
    @Published private(set) var error: Error?
    
    private let transactionsService: TransactionsServiceProtocol
    
    init(transactionsService: TransactionsServiceProtocol = TransactionsService()) {
        self.transactionsService = transactionsService
    }
    
    func loadTransactions() async {
        isLoading = true
        error = nil
        
        do {
            let transactions = try await transactionsService.fetchTransactions()
            groupTransactions(transactions)
            isLoading = false
        } catch {
            self.error = error
            isLoading = false
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
}
