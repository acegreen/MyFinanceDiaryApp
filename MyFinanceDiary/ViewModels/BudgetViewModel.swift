import SwiftUI

class BudgetViewModel: ObservableObject {
    @Published var currentMonth = "August"
    @Published var budgetSummary: Budget.BudgetSummary

    @Published var incomeCategories: [Budget.BudgetCategory] = [
        Budget.BudgetCategory(name: "Salary", spent: 3000, total: 3000, color: .green)
    ]
    
    @Published var expenseCategories: [Budget.BudgetCategory] = [
        Budget.BudgetCategory(name: "Auto & transport", spent: 750, total: 1350, color: .green),
        Budget.BudgetCategory(name: "Auto insurance", spent: 400, total: 500, color: .orange),
        Budget.BudgetCategory(name: "Auto payment", spent: 300, total: 600, color: .green),
        Budget.BudgetCategory(name: "Gas & fuel", spent: 50, total: 250, color: .green)
    ]
    
    init() {
        let totalIncome = 3000.0 // This should match your income categories total
        self.budgetSummary = Budget.BudgetSummary(
            totalIncome: totalIncome,
            totalBudget: 2550,
            totalSpent: 738
        )
    }
    
    var totalIncome: Double {
        incomeCategories.reduce(0) { $0 + $1.spent }
    }
    
    var formattedTotalIncome: String {
        String(format: "$%.0f", totalIncome)
    }
    
    var formattedRemaining: String {
        String(format: "$%.0f", budgetSummary.remaining)
    }
    
    func getProgress(for category: Budget.BudgetCategory) -> Double {
        category.spent / category.total
    }
    
    func getRemainingAmount(for category: Budget.BudgetCategory) -> String {
        let remaining = category.total - category.spent
        return "$\(Int(remaining)) left"
    }
}
