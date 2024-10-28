import SwiftUI
import SwiftData

@MainActor
let previewContainer: ModelContainer = {
    do {
        let container = try ModelContainer(for: Transaction.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        let context = container.mainContext
        Task {
            await addSampleDataIfNeeded(to: context)
        }
        return container
    } catch {
        fatalError("Failed to create model container for previewing: \(error.localizedDescription)")
    }
}()

@MainActor
let previewAppState: AppState = {
    let appState = AppState()
    // Initialize appState with any necessary mock data or settings
    return appState
}()

@MainActor
let previewdashboardViewModel: DashboardViewModel = {
    let viewModel = DashboardViewModel()
    // Sample data is already set up in init()
    return viewModel
}()

@MainActor
func addSampleDataIfNeeded(to context: ModelContext) async {
    let fetchDescriptor = FetchDescriptor<Transaction>(predicate: nil, sortBy: [SortDescriptor(\.date)])
    
    do {
        let existingTransactions = try context.fetch(fetchDescriptor)
        if existingTransactions.isEmpty {
            addSampleData(modelContext: context)
        }
    } catch {
        print("Failed to fetch existing transactions: \(error)")
    }
}

@MainActor
func addSampleData(modelContext: ModelContext) {
    let sampleTransactions = [
        Transaction(
            date: Date().addingTimeInterval(-7 * 24 * 60 * 60),
            transactionDescription: "Grocery Shopping",
            amount: 156.78,
            type: .debit
        ),
        Transaction(
            date: Date().addingTimeInterval(-5 * 24 * 60 * 60),
            transactionDescription: "Salary Deposit",
            amount: 3500.00,
            type: .credit
        ),
        Transaction(
            date: Date().addingTimeInterval(-3 * 24 * 60 * 60),
            transactionDescription: "Restaurant Bill",
            amount: 85.50,
            type: .debit
        ),
        Transaction(
            date: Date().addingTimeInterval(-2 * 24 * 60 * 60),
            transactionDescription: "Gas Station",
            amount: 45.67,
            type: .debit
        ),
        Transaction(
            date: Date().addingTimeInterval(-1 * 24 * 60 * 60),
            transactionDescription: "Online Shopping",
            amount: 129.99,
            type: .debit
        ),
        Transaction(
            date: Date(),
            transactionDescription: "Freelance Payment",
            amount: 750.00,
            type: .credit
        )
    ]
    
    for transaction in sampleTransactions {
        modelContext.insert(transaction)
    }
    
    do {
        try modelContext.save()
    } catch {
        print("Failed to save sample data: \(error)")
    }
}

// Add this extension at the bottom of the file
extension View {
    func withPreviewEnvironment() -> some View {
        self
            .modelContainer(previewContainer)
            .environmentObject(previewAppState)
            .environmentObject(previewdashboardViewModel)
    }
}
