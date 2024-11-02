import Inject
import SwiftData
import SwiftUI

@MainActor
final class AppState: ObservableObject {
    static let shared = AppState()

    // MARK: - Properties

    let modelContext: ModelContext

    // MARK: - Services

    @Published var authenticationService: AuthenticationService
    @Published var plaidService: PlaidService

    // MARK: - ViewModels

    @Published var loginViewModel: LoginViewModel
    @Published var mainViewModel: MainViewModel
    @Published var dashboardViewModel: DashboardViewModel
    @Published var budgetViewModel: BudgetViewModel
    @Published var creditScoreViewModel: CreditScoreViewModel
    @Published var transactionsViewModel: TransactionsViewModel
    @Published var transactionDetailsViewModel: TransactionDetailsViewModel

    @Published var showPlaidLink = false

    private init() {
        // Create persistence stack first without using self
        let persistence = Self.createPersistenceStack()
        modelContext = persistence.context
        let plaidService = PlaidService(modelContext: modelContext)

        // Initialize services
        authenticationService = AuthenticationService()
        self.plaidService = PlaidService(modelContext: modelContext)

        // Initialize ViewModels
        loginViewModel = LoginViewModel()
        mainViewModel = MainViewModel(plaidService: plaidService)
        dashboardViewModel = DashboardViewModel()
        budgetViewModel = BudgetViewModel()
        creditScoreViewModel = CreditScoreViewModel()
        transactionsViewModel = TransactionsViewModel(modelContext: modelContext)
        transactionDetailsViewModel = TransactionDetailsViewModel(modelContext: modelContext)

        showPlaidLink = false
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
                PaymentMeta.self,
                PersonalFinanceCategory.self,
            ])

            let modelConfiguration = ModelConfiguration(
                schema: schema,
                isStoredInMemoryOnly: false
            )

            let container = try ModelContainer(
                for: schema,
                configurations: [modelConfiguration]
            )

            print("✅ ModelContainer created successfully")
            return (container, container.mainContext)
        } catch {
            print("❌ Failed to create ModelContainer: \(error)")
            fatalError("Could not create ModelContainer: \(error)")
        }
    }
}
