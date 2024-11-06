import SwiftUI
import SwiftData

@MainActor
class TransactionDetailsViewModel: ObservableObject {
    @Published private(set) var transaction: Transaction?
    @Published var isLoading: Bool = false
    @Published var error: Error?
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func setTransaction(_ transaction: Transaction) {
        self.transaction = transaction
    }
    
    var formattedAddress: String? {
        guard let location = transaction?.location else { return nil }

        var components: [String] = []
        if let address = location.address { components.append(address) }
        if let city = location.city { components.append(city) }
        if let region = location.region { components.append(region) }
        if let postalCode = location.postalCode { components.append(postalCode) }
        
        return components.isEmpty ? nil : components.joined(separator: ", ")
    }
} 
