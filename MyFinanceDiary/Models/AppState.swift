import SwiftUI
import SwiftData
import Inject

@MainActor
final class AppState: ObservableObject {
    static let shared = AppState()
    
    // MARK: - Properties
    let modelContext: ModelContext
    
    // MARK: - Services
    let authenticationService: AuthenticationService
    let plaidService: PlaidService
    
    // MARK: - ViewModels
    @Published var loginViewModel: LoginViewModel
    @Published var dashboardViewModel: DashboardViewModel
    @Published var budgetViewModel: BudgetViewModel
    @Published var creditScoreViewModel: CreditScoreViewModel
    @Published var transactionsViewModel: TransactionsViewModel
    @Published var transactionDetailsViewModel: TransactionDetailsViewModel
    
    @Published var showPlaidLink = false

    private init() {
        // Create persistence stack first without using self
        let persistence = Self.createPersistenceStack()
        self.modelContext = persistence.context
        
        // Initialize services
        self.authenticationService = AuthenticationService()
        self.plaidService = PlaidService(modelContext: modelContext)
        
        // Initialize ViewModels
        self.loginViewModel = LoginViewModel()
        self.dashboardViewModel = DashboardViewModel(plaidService: plaidService)
        self.budgetViewModel = BudgetViewModel()
        self.creditScoreViewModel = CreditScoreViewModel()
        self.transactionsViewModel = TransactionsViewModel(modelContext: modelContext)
        self.transactionDetailsViewModel = TransactionDetailsViewModel(modelContext: modelContext)
        
        self.showPlaidLink = false
    }
    
    // Changed to static method so it can be called before initialization
    private static func createPersistenceStack() -> (container: ModelContainer, context: ModelContext) {
        do {
            let schema = Schema([
                Provider.self,
                Item.self,
                Account.self,
                Transaction.self,
                Location.self,
                PaymentMeta.self
            ])
            let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
            let container = try ModelContainer(for: schema, configurations: [modelConfiguration])
            return (container, container.mainContext)
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }
}
