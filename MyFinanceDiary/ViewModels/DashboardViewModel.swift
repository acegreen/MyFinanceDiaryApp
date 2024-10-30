import Foundation

@MainActor
class DashboardViewModel: ObservableObject {
    @Published var accounts: [Account] = []
    @Published var selectedSegment: ChartSegment = .netWorth {
        didSet {
            updateChartData() // Automatically update when segment changes
        }
    }
    @Published var chartData: [FinancialChartView.FinancialDataPoint] = []
    @Published var creditScore: Int = 821
    
    enum ChartSegment: String, CaseIterable {
        case netWorth = "Net worth"
        case spending = "Spending"
        case cash = "Cash"
        case investments = "Investments"
    }
    
    init() {
        setupSampleData()
        updateChartData()
    }
    
    private func setupSampleData() {
        accounts = [
            Account(accountId: "1", balances: Balances(current: 5732.0), name: "Checking", type: .depository),
            Account(accountId: "2", balances: Balances(current: -4388.0), name: "Credit Card", type: .credit),
            Account(accountId: "3", balances: Balances(current: 82386.0), name: "Investment", type: .investment),
            Account(accountId: "4", balances: Balances(current: 302225.0), name: "Property", type: .other)
        ]
    }
    
    func updateChartData() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        switch selectedSegment {
        case .netWorth:
            let totalNetWorth = accounts.reduce(0.0) { $0 + $1.balances.current }
            chartData = createTrendData(startAmount: totalNetWorth * 0.97, endAmount: totalNetWorth)
            
        case .spending:
            let currentSpending = 2500.0
            chartData = createTrendData(startAmount: currentSpending * 1.2, endAmount: currentSpending)
            
        case .cash:
            if let cashAccount = accounts.first(where: { $0.type == .depository }) {
                chartData = createTrendData(startAmount: cashAccount.balances.current * 1.1, endAmount: cashAccount.balances.current)
            }
            
        case .investments:
            if let investmentAccount = accounts.first(where: { $0.type == .investment }) {
                chartData = createTrendData(startAmount: investmentAccount.balances.current * 0.95, endAmount: investmentAccount.balances.current)
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
        updateChartData()
    }
    
    var currentAmount: String {
        switch selectedSegment {
        case .netWorth:
            let total = accounts.reduce(0.0) { $0 + $1.balances.current }
            return formatAmount(total)
        case .spending:
            return formatAmount(2500) // TODO: Get actual monthly spending
        case .cash:
            let cashAmount = accounts.first(where: { $0.type == .depository })?.balances.current ?? 0
            return formatAmount(cashAmount)
        case .investments:
            let investmentAmount = accounts.first(where: { $0.type == .investment })?.balances.current ?? 0
            return formatAmount(investmentAmount)
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
    
    func formatAmount(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: amount)) ?? "$0"
    }
    
    func updateCreditScore(_ newScore: Int) {
        creditScore = newScore
        objectWillChange.send()
    }
}
