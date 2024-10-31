import SwiftUI
import SwiftData
import Inject

#if DEBUG
final class PreviewHelper {
    @ObserveInjection var inject

    @MainActor
    static let previewAppState: AppState = {
        let appState = AppState.shared
        appState.dashboardViewModel = PreviewHelper.previewdashboardViewModel
        appState.transactionsViewModel = PreviewHelper.previewTransactionViewModel
        return appState
    }()

    @MainActor
    static let previewdashboardViewModel: DashboardViewModel = {
        let modelContext = PreviewHelper.previewAppState.modelContext
        let viewModel = DashboardViewModel(plaidService: PlaidService(modelContext: modelContext))
        viewModel.accounts = [
            DashboardAccount(id: .cash, value: 5732.0),
            DashboardAccount(id: .creditCards, value: -4388.0),
            DashboardAccount(id: .investments, value: 82386.0),
            DashboardAccount(id: .property, value: 302225.0)
        ]
        return viewModel
    }()

    @MainActor
    static let previewTransactionViewModel: TransactionsViewModel = {

        let modelContext = PreviewHelper.previewAppState.modelContext
        let viewModel = TransactionsViewModel(modelContext: modelContext)
        viewModel.groupTransactions(getMockTransactions())
        return viewModel
    }()

//    @MainActor
//    static func addSampleDataIfNeeded(transactions: [Transaction], to context: ModelContext) async {
//        guard ProcessInfo.processInfo.isPreview else { return }
//
//        let mockTransactionIds = transactions.map { $0.transactionId }
//        let fetchDescriptor = FetchDescriptor<Transaction>(
//            predicate: #Predicate<Transaction> { transaction in
//                mockTransactionIds.contains(transaction.transactionId)
//            }
//        )
//
//        do {
//            let existingTransactions = try context.fetch(fetchDescriptor)
//            if existingTransactions.isEmpty {
//                print("📊 Adding sample preview data")
//                addSampleData(modelContext: context)
//            } else {
//                print("📊 Preview data already exists, skipping insertion")
//            }
//        } catch {
//            print("Failed to fetch existing transactions: \(error)")
//        }
//    }
//
//    @MainActor
//    static func addSampleData(modelContext: ModelContext) {
//        let sampleTransactions = getMockTransactions()
//
//        for transaction in sampleTransactions {
//            modelContext.insert(transaction)
//        }
//
//        do {
//            try modelContext.save()
//        } catch {
//            print("Failed to save sample data: \(error)")
//        }
//    }

    static func getMockTransactions() -> [Transaction] {
        return [
            Transaction(
                accountId: "ny198oNPRMfWDx8L8aGPsv5LlDpdgjcAJgxdl",
                amount: 500,
                category: [.foodAndDrink, .restaurants],
                date: DateFormatter.plaidDate.date(from: "2024-10-31") ?? Date(),
                isoCurrencyCode: "USD",
                name: "Tectra Inc",
                paymentChannel: .inStore,
                pending: false,
                transactionId: "vx9J8z1LgMcApwKGKMElhRy9oNqdxeCqZ77Nz",
                transactionType: .place,
                accountOwner: nil as String?,
                authorizedDate: nil as Date?,
                authorizedDatetime: nil as Date?,
                categoryId: "13005000",
                checkNumber: nil as String?,
                counterparties: [] as [Counterparty],
                datetime: nil as Date?,
                location: Location(
                    address: nil,
                    city: nil,
                    country: nil,
                    lat: nil,
                    lon: nil,
                    postalCode: nil,
                    region: nil,
                    storeNumber: nil
                ),
                logoUrl: nil as String?,
                merchantEntityId: nil as String?,
                merchantName: nil as String?
            )
        ]
    }
}

extension ProcessInfo {
    var isPreview: Bool {
        environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    }
}

// Preview-specific extensions
extension View {
    func withPreviewEnvironment() -> some View {
        self
            .environmentObject(PreviewHelper.previewAppState)
    }
}
#endif
