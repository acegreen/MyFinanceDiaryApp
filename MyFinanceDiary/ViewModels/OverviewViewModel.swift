import Foundation

@MainActor
class OverviewViewModel: ObservableObject {
    @Published var accounts: [Account] = []
    @Published var netWorthData: [NetWorthDataPoint] = []
    
    init() {
        // Initialize with sample data for now
        setupSampleData()
    }
    
    private func setupSampleData() {
        accounts = [
            Account(type: .cash, amount: 5732),
            Account(type: .creditCards, amount: -4388),
            Account(type: .investments, amount: 82386),
            Account(type: .property, amount: 302225)
        ]
        
        // Use the existing sample data for net worth chart
        netWorthData = NetWorthChartView.sampleData
    }
    
    var totalNetWorth: Double {
        accounts.reduce(0) { $0 + $1.amount }
    }
    
    func formatAmount(_ amount: Double) -> String {
        let isNegative = amount < 0
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        
        return formatter.string(from: NSNumber(value: abs(amount))) ?? "$0"
    }
}
