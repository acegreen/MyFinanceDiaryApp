import Foundation
import SwiftUI

struct Budget: Identifiable {
    struct BudgetCategory: Identifiable {
        let id = UUID()
        let category: TransactionCategory
        let spent: Double
        let total: Double

        var color: Color {
            switch category {
            case .foodAndDrink, .restaurants, .fastFood, .coffeeShop:
                return .orange
            case .shopping, .shops, .sportingGoods:
                return .blue
            case .travel, .transportation, .taxi, .airlinesAndAviation:
                return .green
            case .entertainment, .recreation:
                return .purple
            case .rent, .utilities:
                return .red
            case .healthcare, .service:
                return .pink
            case .deposit, .payroll:
                return .mint
            case .creditCard, .payment, .transfer:
                return .indigo
            default:
                return .gray
            }
        }

        func getProgress() -> Double {
            spent / total
        }

        func getRemaining() -> String {
            let remaining = total - spent
            return String(format: "$%.0f", remaining)
        }
    }
    
    struct BudgetSummary {
        let totalIncome: Double
        let totalBudget: Double
        let totalSpent: Double
        
        var remaining: Double { totalBudget - totalSpent }
    }
    let id = UUID()
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

extension Budget {

    var totalIncome: Double {
        incomeCategories.reduce(0) { $0 + $1.spent }
    }

    var totalExpenses: Double {
        expenseCategories.reduce(0) { $0 + $1.spent }
    }

    var formattedTotalIncome: String {
        NumberFormatter.formatAmount(summary.totalIncome)
    }

    var formattedTotalExpenses: String {
        "-\(NumberFormatter.formatAmount(totalExpenses))"
    }

    var formattedRemaining: String {
        String(format: "$%.0f", summary.remaining)
    }
}
