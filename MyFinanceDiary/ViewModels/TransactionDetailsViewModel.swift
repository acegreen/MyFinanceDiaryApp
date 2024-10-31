import SwiftUI
import SwiftData

@MainActor
class TransactionDetailsViewModel: ObservableObject {
    @Published var transaction: Transaction?
    @Published var isLoading: Bool = false
    @Published var error: Error?
    private let modelContext: ModelContext

    init(transaction: Transaction? = nil, modelContext: ModelContext) {
        self.transaction = transaction
        self.modelContext = modelContext
    }
    
    func getTransaction(id: String) throws -> Transaction? {
        if let existingTransaction = transaction, existingTransaction.transactionId == id {
            return existingTransaction
        }
        
        let descriptor = FetchDescriptor<Transaction>()
        let transactions = try modelContext.fetch(descriptor)
        return transactions
            .first { $0.transactionId == id }
    }

    func setTransaction(_ transaction: Transaction) {
        self.transaction = transaction
    }

    func clearTransaction() {
        self.transaction = nil
    }
    
    var formattedAddress: String? {
        guard let transaction = transaction else { return nil }
        guard let location = transaction.location else { return nil }
        
        var components: [String] = []
        if let address = location.address { components.append(address) }
        if let city = location.city { components.append(city) }
        if let region = location.region { components.append(region) }
        if let postalCode = location.postalCode { components.append(postalCode) }
        
        return components.isEmpty ? nil : components.joined(separator: ", ")
    }
} 
