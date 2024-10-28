import Foundation
import SwiftUI

struct Budget {
    struct BudgetCategory: Identifiable {
        let id = UUID()
        let name: String
        let spent: Double
        let total: Double
        let color: Color
    }
    
    struct BudgetSummary {
        let totalIncome: Double
        let totalBudget: Double
        let totalSpent: Double
        
        var remaining: Double { totalBudget - totalSpent }
    }
    var summary: BudgetSummary
    var incomeCategories: [BudgetCategory]
    var expenseCategories: [BudgetCategory]
    var month: String
    
    init(month: String, 
         incomeCategories: [BudgetCategory], 
         expenseCategories: [BudgetCategory]) {
        self.month = month
        self.incomeCategories = incomeCategories
        self.expenseCategories = expenseCategories
        
        let totalIncome = incomeCategories.reduce(0) { $0 + $1.spent }
        let totalBudget = expenseCategories.reduce(0) { $0 + $1.total }
        let totalSpent = expenseCategories.reduce(0) { $0 + $1.spent }
        
        self.summary = BudgetSummary(
            totalIncome: totalIncome,
            totalBudget: totalBudget,
            totalSpent: totalSpent
        )
    }
}
