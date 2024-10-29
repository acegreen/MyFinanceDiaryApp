import SwiftUI
import SwiftData
import Inject

@MainActor
class AppState: ObservableObject {
    @ObserveInjection var inject
    
    let container: ModelContainer
    
    // Services
    let authenticationService: AuthenticationService
    let transactionService: TransactionsService
    let plaidService: PlaidService
    
    // ViewModels
    @Published var dashboardViewModel: DashboardViewModel
    @Published var budgetViewModel: BudgetViewModel
    @Published var transactionsViewModel: TransactionsViewModel
    @Published var creditScoreViewModel: CreditScoreViewModel

    init() {
        do {
            let schema = Schema([Transaction.self])
            let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
            container = try ModelContainer(for: schema, configurations: [modelConfiguration])
            
            // Initialize services
            authenticationService = AuthenticationService()
            transactionService = TransactionsService(modelContext: container.mainContext)
            plaidService = PlaidService()
            
            // Initialize ViewModels
            dashboardViewModel = DashboardViewModel()
            budgetViewModel = BudgetViewModel()
            transactionsViewModel = TransactionsViewModel(modelContext: container.mainContext)
            creditScoreViewModel = CreditScoreViewModel(initialScore: 0) // Set appropriate initial value
            
            // Add sample data if needed
            Task {
                await addSampleDataIfNeeded(to: container.mainContext)
            }
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }
    
    func addSampleDataIfNeeded(to context: ModelContext) async {
        // Implement your sample data logic here
    }
}

#if DEBUG
extension AppState {
    static var preview: AppState {
        let appState = AppState()
        // Add any preview-specific setup here
        return appState
    }
}
#endif
