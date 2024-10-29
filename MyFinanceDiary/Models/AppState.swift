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
    @Published var dashboardViewModel: DashboardViewModel
    @Published var budgetViewModel: BudgetViewModel
    @Published var transactionsViewModel: TransactionsViewModel
    @Published var creditScoreViewModel: CreditScoreViewModel
    @Published var loginViewModel: LoginViewModel
    
    @Published var showPlaidLink = false
    
    @ObserveInjection var inject
    
    init() {
        (container, modelContext) = Self.setupPersistence()
        
        // Initialize services
        authenticationService = AuthenticationService()
        plaidService = PlaidService()
        transactionService = TransactionsService(plaidService: plaidService, modelContext: modelContext)
        
        // Initialize ViewModels with dependencies
        dashboardViewModel = DashboardViewModel()
        budgetViewModel = BudgetViewModel()
        transactionsViewModel = TransactionsViewModel(
            transactionsService: transactionService,
            plaidService: plaidService,
            modelContext: modelContext
        )
        creditScoreViewModel = CreditScoreViewModel(initialScore: 0)
        loginViewModel = LoginViewModel()
    }
    
    // Add a convenience method to inject all ViewModels into the environment
    func injectViewModels<Content: View>(into view: Content) -> some View {
        view
            .environmentObject(dashboardViewModel)
            .environmentObject(budgetViewModel)
            .environmentObject(transactionsViewModel)
            .environmentObject(creditScoreViewModel)
            .environmentObject(loginViewModel)
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
