import SwiftUI

@MainActor
class BudgetViewModel: ObservableObject {
    @Published var currentMonth: String = "August"
    @Published var budgetSummary: Budget.BudgetSummary
    @Published var incomeCategories: [Budget.BudgetCategory] = [
        Budget.BudgetCategory(name: "Salary", spent: 3000, total: 3000, color: .primaryGreen)
    ]
    @Published var expenseCategories: [Budget.BudgetCategory] = [
        Budget.BudgetCategory(name: "Auto & transport", spent: 750, total: 1350, color: .primaryGreen),
        Budget.BudgetCategory(name: "Auto insurance", spent: 400, total: 500, color: .vibrantOrange),
        Budget.BudgetCategory(name: "Auto payment", spent: 300, total: 600, color: .primaryGreen),
        Budget.BudgetCategory(name: "Gas & fuel", spent: 50, total: 250, color: .primaryGreen)
    ]
    
    init() {
        // Initialize budgetSummary with all required parameters
        self.budgetSummary = Budget.BudgetSummary(
            totalIncome: 3000,  // From income categories
            totalBudget: 2650,  // Sum of expense categories totals
            totalSpent: 1500    // Sum of expense categories spent
        )
    }
    
    var totalIncome: Double {
        incomeCategories.reduce(0) { $0 + $1.spent }
    }
    
    var totalExpenses: Double {
       expenseCategories.reduce(0) { $0 + $1.spent }
    }
    
    var formattedTotalIncome: String {
        "$\(Int(budgetSummary.totalIncome))"
    }
    
    var formattedRemaining: String {
        String(format: "$%.0f", budgetSummary.remaining)
    }
    
    var formattedIncome: String {
        NumberFormatter.formatAmount(totalIncome)
    }
    
    var formattedExpenses: String {
        "-\(NumberFormatter.formatAmount(totalExpenses))"
    }
    
    var formattedTotalExpenses: String {
        "-$\(Int(budgetSummary.totalSpent))"
    }
    
    func getProgress(for category: Budget.BudgetCategory) -> Double {
        Double(category.spent) / Double(category.total)
    }
    
    func getRemainingAmount(for category: Budget.BudgetCategory) -> String {
        let remaining = category.total - category.spent
        return "$\(Int(remaining)) left"
    }
}
