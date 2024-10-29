import SwiftUI
import SwiftData
import Inject

@MainActor
class AppState: ObservableObject {
    // MARK: - Properties
    let container: ModelContainer
    private let modelContext: ModelContext
    
    // MARK: - Services
    let authenticationService: AuthenticationService
    let plaidService: PlaidService
    let transactionService: TransactionsService
    
    // MARK: - ViewModels
    @Published var loginViewModel: LoginViewModel
    @Published var dashboardViewModel: DashboardViewModel
    @Published var budgetViewModel: BudgetViewModel
    @Published var creditScoreViewModel: CreditScoreViewModel
    @Published var transactionsViewModel: TransactionsViewModel
    @Published var transactionDetailsViewModel: TransactionDetailsViewModel
    
    @Published var showPlaidLink = false
    
    @ObserveInjection var inject
    
    init() {
        (container, modelContext) = Self.setupPersistence()
        
        // Initialize services
        authenticationService = AuthenticationService()
        plaidService = PlaidService()
        transactionService = TransactionsService(plaidService: plaidService, modelContext: modelContext)
        
        // Initialize ViewModels with dependencies
        loginViewModel = LoginViewModel()
        dashboardViewModel = DashboardViewModel()
        budgetViewModel = BudgetViewModel()
        creditScoreViewModel = CreditScoreViewModel(initialScore: 0)
        transactionsViewModel = TransactionsViewModel(
            transactionsService: transactionService,
            plaidService: plaidService,
            modelContext: modelContext
        )
        transactionDetailsViewModel = TransactionDetailsViewModel()
    }
    
    // Add a convenience method to inject all ViewModels into the environment
    func injectViewModels<Content: View>(into view: Content) -> some View {
        view
            .environmentObject(loginViewModel)
            .environmentObject(dashboardViewModel)
            .environmentObject(budgetViewModel)
            .environmentObject(creditScoreViewModel)
            .environmentObject(transactionsViewModel)
            .environmentObject(transactionDetailsViewModel)
    }
}

// MARK: - Setup Methods
private extension AppState {
    static func setupPersistence() -> (ModelContainer, ModelContext) {
        do {
            let schema = Schema([Transaction.self])
            let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
            let container = try ModelContainer(for: schema, configurations: [modelConfiguration])
            return (container, container.mainContext)
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
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
