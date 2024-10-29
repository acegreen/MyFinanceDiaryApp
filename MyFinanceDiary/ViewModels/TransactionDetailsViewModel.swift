import SwiftUI

@MainActor
class TransactionDetailsViewModel: ObservableObject {
    @Published var transaction: Transaction?

    init(transaction: Transaction? = nil) {
        self.transaction = transaction
    }
    
    func getTransaction(id: String) -> Transaction? {
        return transaction?.transactionId == id ? transaction : nil
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
