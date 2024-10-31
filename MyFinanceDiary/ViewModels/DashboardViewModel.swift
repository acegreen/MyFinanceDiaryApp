import Foundation

@MainActor
class DashboardViewModel: ObservableObject {
    @Published var provider: Provider?
    @Published var selectedSegment: ChartSegment = .netWorth {
        didSet {
            updateChart()
        }
    }
    @Published var isLoading: Bool = false
    @Published var error: Error?
    var plaidService: PlaidService
    var accounts: [DashboardAccount] = []
    var chartData: [FinancialChartView.FinancialDataPoint] = []
    var creditScore: Int = 821
    
    enum ChartSegment: String, CaseIterable {
        case netWorth = "Net worth"
        case spending = "Spending"
        case cash = "Cash"
        case investments = "Investments"
    }
    
    init(plaidService: PlaidService) {
        self.plaidService = plaidService
        setupAccounts()
        updateChart()
    }

    func fetchProvider() async throws {
        provider = try await plaidService.fetchProvider()
    }
    
    private func setupAccounts() {
        accounts = [
            DashboardAccount(id: .cash, value: 5732.0),
            DashboardAccount(id: .creditCards, value: -4388.0),
            DashboardAccount(id: .investments, value: 82386.0),
            DashboardAccount(id: .property, value: 302225.0)
        ]
    }
    
    func updateChart() {
        switch selectedSegment {
        case .netWorth:
            let totalNetWorth = accounts.reduce(0.0) { $0 + $1.value }
            chartData = createTrendData(startAmount: totalNetWorth * 0.97, endAmount: totalNetWorth)
            
        case .spending:
            let currentSpending = 2500.0
            chartData = createTrendData(startAmount: currentSpending * 1.2, endAmount: currentSpending)
            
        case .cash:
            if let cashAccount = accounts.first(where: { $0.id == .cash }) {
                chartData = createTrendData(startAmount: cashAccount.value * 1.1, endAmount: cashAccount.value)
            }
            
        case .investments:
            if let investmentAccount = accounts.first(where: { $0.id == .investments }) {
                chartData = createTrendData(startAmount: investmentAccount.value * 0.95, endAmount: investmentAccount.value)
            }
        }
        objectWillChange.send()
    }
    
    private func createTrendData(startAmount: Double, endAmount: Double) -> [FinancialChartView.FinancialDataPoint] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        return (0...3).map { weekOffset -> FinancialChartView.FinancialDataPoint in
            let date = calendar.date(byAdding: .weekOfMonth, value: -weekOffset, to: today)!
            let progress = Double(3 - weekOffset) / 3.0
            let amount = startAmount + (endAmount - startAmount) * progress
            return .init(date: date, amount: amount)
        }
        .reversed()
    }
    
    func selectSegment(_ segment: ChartSegment) {
        selectedSegment = segment
        updateChart()
    }
    
    var currentAmount: String {
        switch selectedSegment {
        case .netWorth:
            let total = accounts.reduce(0.0) { $0 + $1.value }
            return NumberFormatter.formatAmount(total)
        case .spending:
            return NumberFormatter.formatAmount(2500) // TODO: Get actual monthly spending
        case .cash:
            let cashAmount = accounts.first(where: { $0.id == .cash })?.value ?? 0
            return NumberFormatter.formatAmount(cashAmount)
        case .investments:
            let investmentAmount = accounts.first(where: { $0.id == .investments })?.value ?? 0
            return NumberFormatter.formatAmount(investmentAmount)
        }
    }
    
    var changeDescription: String {
        switch selectedSegment {
        case .netWorth:
            return "$200 this month"
        case .spending:
            return "$300 less than last month"
        case .cash:
            return "$150 this month"
        case .investments:
            return "$450 this month"
        }
    }
    
    var changeIsPositive: Bool {
        switch selectedSegment {
        case .netWorth, .investments:
            return true
        case .spending:
            return false // For spending, down is good
        case .cash:
            return false
        }
    }
    
    func updateCreditScore(_ newScore: Int) {
        creditScore = newScore
        objectWillChange.send()
    }
}
