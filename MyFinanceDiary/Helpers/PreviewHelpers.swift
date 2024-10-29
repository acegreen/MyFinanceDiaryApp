import SwiftUI
import SwiftData

#if DEBUG
enum PreviewHelpers {
    static func getMockTransactions() -> [Transaction] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return [
            Transaction(
                amount: -12.99,
                date: dateFormatter.date(from: "2024-03-20") ?? Date(),
                name: "Starbucks Coffee",
                merchantName: "Starbucks",
                pending: false,
                transactionId: "tx_1"
            ),
            Transaction(
                amount: -45.50,
                date: dateFormatter.date(from: "2024-03-19") ?? Date(),
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

    @MainActor
    static let previewContainer: ModelContainer = {
        do {
            let container = try ModelContainer(for: Transaction.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
            let context = container.mainContext
            if ProcessInfo.processInfo.isPreview {
                Task {
                    await addSampleDataIfNeeded(to: context)
                }
            }
            return container
        } catch {
            fatalError("Failed to create model container for previewing: \(error.localizedDescription)")
        }
    }()

    @MainActor
    static let previewAppState: AppState = {
        let appState = AppState()
        // Initialize appState with any necessary mock data or settings
        return appState
    }()

    @MainActor
    static let previewdashboardViewModel: DashboardViewModel = {
        let viewModel = DashboardViewModel()
        // Sample data is already set up in init()
        return viewModel
    }()

    @MainActor
    static func addSampleDataIfNeeded(to context: ModelContext) async {
        guard ProcessInfo.processInfo.isPreview else { return }
        
        let mockTransactionIds = getMockTransactions().map { $0.transactionId }
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
            .modelContainer(PreviewHelpers.previewContainer)
            .environmentObject(PreviewHelpers.previewAppState)
            .environmentObject(PreviewHelpers.previewdashboardViewModel)
    }
}
#endif
