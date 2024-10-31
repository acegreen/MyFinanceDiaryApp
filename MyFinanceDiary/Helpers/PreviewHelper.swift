import SwiftUI
import SwiftData

#if DEBUG
final class PreviewHelper {
    @MainActor
    static let previewAppState: AppState = {
        let appState = AppState()
        appState.dashboardViewModel = PreviewHelper.previewdashboardViewModel
        appState.transactionsViewModel = PreviewHelper.previewTransactionViewModel
        return appState
    }()

    @MainActor
    static let previewdashboardViewModel: DashboardViewModel = {
        let viewModel = DashboardViewModel()
        viewModel.accounts = [
            Account(accountId: "1", balances: Balances(current: 5732.0), name: "Checking", type: .depository),
            Account(accountId: "2", balances: Balances(current: -4388.0), name: "Credit Card", type: .credit),
            Account(accountId: "3", balances: Balances(current: 82386.0), name: "Investment", type: .investment),
            Account(accountId: "4", balances: Balances(current: 302225.0), name: "Property", type: .other)
        ]
        return viewModel
    }()

    @MainActor
    static let previewTransactionViewModel: TransactionsViewModel = {

        let modelContext = PreviewHelper.previewAppState.modelContext
        let viewModel = TransactionsViewModel(transactionsService: TransactionsService(plaidService: PlaidService(),
                                                                                       modelContext: modelContext),
                                              modelContext: modelContext)
        viewModel.groupTransactions(getMockTransactions())
        return viewModel
    }()

    @MainActor
    static func addSampleDataIfNeeded(transactions: [Transaction], to context: ModelContext) async {
        guard ProcessInfo.processInfo.isPreview else { return }
        
        let mockTransactionIds = transactions.map { $0.transactionId }
        let fetchDescriptor = FetchDescriptor<Transaction>(
            predicate: #Predicate<Transaction> { transaction in
                mockTransactionIds.contains(transaction.transactionId)
            }
        )
        
        do {
            let existingTransactions = try context.fetch(fetchDescriptor)
            if existingTransactions.isEmpty {
                print("📊 Adding sample preview data")
                addSampleData(modelContext: context)
            } else {
                print("📊 Preview data already exists, skipping insertion")
            }
        } catch {
            print("Failed to fetch existing transactions: \(error)")
        }
    }

    @MainActor
    static func addSampleData(modelContext: ModelContext) {
        let sampleTransactions = getMockTransactions()
        
        for transaction in sampleTransactions {
            modelContext.insert(transaction)
        }
        
        do {
            try modelContext.save()
        } catch {
            print("Failed to save sample data: \(error)")
        }
    }

    static func getMockTransactions() -> [Transaction] {

        return [
            Transaction(
                amount: -12.99,
                date: DateFormatter.plaidDate.date(from: "2024-03-20") ?? Date(),
                name: "Starbucks Coffee",
                merchantName: "Starbucks",
                pending: false,
                transactionId: "tx_1"
            ),
            Transaction(
                amount: -45.50,
                date: DateFormatter.plaidDate.date(from: "2024-03-19") ?? Date(),
                name: "Amazon.com",
                merchantName: "Amazon",
                pending: false,
                transactionId: "tx_2"
            ),
            Transaction(
                amount: -156.78,
                date: Date().addingTimeInterval(-7 * 24 * 60 * 60),
                name: "Grocery Shopping",
                pending: false,
                transactionId: "sample_1"
            ),
            Transaction(
                amount: 3500.00,
                date: Date().addingTimeInterval(-5 * 24 * 60 * 60),
                name: "Salary Deposit",
                pending: false,
                transactionId: "sample_2"
            ),
            Transaction(
                amount: -85.50,
                date: Date().addingTimeInterval(-3 * 24 * 60 * 60),
                name: "Restaurant Bill",
                pending: false,
                transactionId: "sample_3"
            ),
            Transaction(
                amount: -45.67,
                date: Date().addingTimeInterval(-2 * 24 * 60 * 60),
                name: "Gas Station",
                pending: false,
                transactionId: "sample_4"
            ),
            Transaction(
                amount: -129.99,
                date: Date().addingTimeInterval(-1 * 24 * 60 * 60),
                name: "Online Shopping",
                pending: false,
                transactionId: "sample_5"
            ),
            Transaction(
                amount: 750.00,
                date: Date(),
                name: "Freelance Payment",
                pending: false,
                transactionId: "sample_6"
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
