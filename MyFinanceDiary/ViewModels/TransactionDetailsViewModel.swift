import SwiftUI
import SwiftData

@MainActor
class TransactionDetailsViewModel: ObservableObject {
    @Published var transaction: Transaction?
    @Published var isLoading: Bool = false
    @Published var error: Error?
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func loadTransaction(id: String) throws {
        guard transaction?.transactionId != id else { return }

        let descriptor = FetchDescriptor<Transaction>()
        let transactions = try modelContext.fetch(descriptor)
        guard let filteredTransaction = transactions
            .first(where: { $0.transactionId == id }) else { return }
        setTransaction(filteredTransaction)
    }

    func setTransaction(_ transaction: Transaction) {
        self.transaction = transaction
    }

    func clearTransaction() {
        self.transaction = nil
    }
    
    var formattedAddress: String? {
        guard let transaction, let location = transaction.location else { return nil }

        var components: [String] = []
        if let address = location.address { components.append(address) }
        if let city = location.city { components.append(city) }
        if let region = location.region { components.append(region) }
        if let postalCode = location.postalCode { components.append(postalCode) }
        
        return components.isEmpty ? nil : components.joined(separator: ", ")
    }
} 
