import Foundation

@MainActor
class OverviewViewModel: ObservableObject {
    @Published var accounts: [Account] = []
    @Published var selectedSegment: ChartSegment = .netWorth {
        didSet {
            updateChartData() // Automatically update when segment changes
        }
    }
    @Published var chartData: [FinancialDataPoint] = []
    
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
            Account(type: .cash, amount: 5732),
            Account(type: .creditCards, amount: -4388),
            Account(type: .investments, amount: 82386),
            Account(type: .property, amount: 302225)
        ]
    }
    
    func updateChartData() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        switch selectedSegment {
        case .netWorth:
            // TODO: Fetch actual net worth history from CoreData/database
            // Should include: total of all accounts at weekly intervals
            let totalNetWorth = accounts.reduce(0.0) { $0 + $1.amount }
            chartData = createTrendData(startAmount: totalNetWorth * 0.97, endAmount: totalNetWorth)
            
        case .spending:
            // TODO: Fetch actual spending history from transactions
            // Should include: sum of all expenses grouped by week
            let currentSpending = 2500.0
            chartData = createTrendData(startAmount: currentSpending * 1.2, endAmount: currentSpending)
            
        case .cash:
            // TODO: Fetch actual cash account balance history
            // Should include: cash account balance at weekly intervals
            if let cashAccount = accounts.first(where: { $0.type == .cash }) {
                chartData = createTrendData(startAmount: cashAccount.amount * 1.1, endAmount: cashAccount.amount)
            }
            
        case .investments:
            // TODO: Fetch actual investment account balance history
            // Should include: investment account balance at weekly intervals
            if let investmentAccount = accounts.first(where: { $0.type == .investments }) {
                chartData = createTrendData(startAmount: investmentAccount.amount * 0.95, endAmount: investmentAccount.amount)
            }
        }
        
        objectWillChange.send()
    }
    
    // TODO: Replace with actual historical data fetch
    private func createTrendData(startAmount: Double, endAmount: Double) -> [FinancialDataPoint] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        return (0...3).map { weekOffset -> FinancialDataPoint in
            let date = calendar.date(byAdding: .weekOfMonth, value: -weekOffset, to: today)!
            let progress = Double(3 - weekOffset) / 3.0
            let amount = startAmount + (endAmount - startAmount) * progress
            return FinancialDataPoint(date: date, amount: amount)
        }
        .reversed()
    }
    
    func selectSegment(_ segment: ChartSegment) {
        selectedSegment = segment
        updateChartData()
    }
    
    var currentAmount: String {
        // TODO: Replace with actual data
        switch selectedSegment {
        case .netWorth:
            let total = accounts.reduce(0.0) { $0 + $1.amount }
            return formatAmount(total)
        case .spending:
            return formatAmount(2500) // TODO: Get actual monthly spending
        case .cash:
            let cashAmount = accounts.first(where: { $0.type == .cash })?.amount ?? 0
            return formatAmount(cashAmount)
        case .investments:
            let investmentAmount = accounts.first(where: { $0.type == .investments })?.amount ?? 0
            return formatAmount(investmentAmount)
        }
    }
    
    var changeDescription: String {
        // TODO: Calculate actual changes based on historical data
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
        // TODO: Calculate based on actual historical data
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
}
