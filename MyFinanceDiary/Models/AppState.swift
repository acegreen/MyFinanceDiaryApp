import SwiftUI
import SwiftData
import Inject

@MainActor
class AppState: ObservableObject {

    // MARK: - Properties
    let container: ModelContainer
    let modelContext: ModelContext
    
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
        creditScoreViewModel = CreditScoreViewModel()
        transactionsViewModel = TransactionsViewModel(
            transactionsService: transactionService,
            modelContext: modelContext
        )
        transactionDetailsViewModel = TransactionDetailsViewModel()
    }

    static func setupPersistence() -> (ModelContainer, ModelContext) {
        do {
            let schema = Schema([Account.self, Transaction.self])
            let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
            let container = try ModelContainer(for: schema, configurations: [modelConfiguration])
            return (container, container.mainContext)
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }
}
