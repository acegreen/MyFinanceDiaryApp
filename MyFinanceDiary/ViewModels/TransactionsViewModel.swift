import SwiftUI
import Combine

@MainActor
class TransactionsViewModel: ObservableObject {
    @Published private(set) var groupedTransactions: [Date: [Transaction]] = [:]
    @Published private(set) var isLoading = false
    @Published var error: Error?
    
    private let transactionsService: TransactionsServiceProtocol
    private let plaidService: PlaidService
    private var plaidSetupCancellable: AnyCancellable?
    
    init(transactionsService: TransactionsServiceProtocol = TransactionsService(),
         plaidService: PlaidService = PlaidService()) {
        self.transactionsService = transactionsService
        self.plaidService = plaidService
        
        // Watch for Plaid setup completion
        plaidSetupCancellable = plaidService.$didCompletePlaidSetup
            .filter { $0 }
            .sink { [weak self] _ in
                print("Plaid setup completed, retrying transaction fetch")
                self?.retryLoadTransactions()
            }
    }
    
    func loadTransactions() {
        Task {
            isLoading = true
            defer { isLoading = false }
            
            do {
                let transactions = try await transactionsService.fetchTransactions()
                groupTransactions(transactions)
            } catch PlaidError.noPlaidConnection {
                print("No Plaid connection, initiating setup")
                plaidService.setupPlaidLink()
            } catch {
                self.error = error
            }
        }
    }
    
    private func retryLoadTransactions() {
        Task {
            do {
                let transactions = try await transactionsService.fetchTransactions()
                groupTransactions(transactions)
            } catch {
                self.error = error
            }
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
