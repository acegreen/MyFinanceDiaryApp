import SwiftUI

@MainActor
class BudgetViewModel: ObservableObject {
    @Published var budget: Budget

    init() {
        let month = "June"
        let incomeCategories: [Budget.BudgetCategory] = [
            .init(subCategory: .payroll, type: .income, spent: 5000, total: 5000),
            .init(subCategory: .deposit, type: .income, spent: 200, total: 200),
        ]
        let expenseCategories: [Budget.BudgetCategory] = [
            // Housing & Utilities (30-35% of income)
            .init(subCategory: .rent, type: .expense, spent: 1600, total: 1800),
            .init(subCategory: .utilities, type: .expense, spent: 150, total: 200),

            // Food & Dining (10-15%)
            .init(subCategory: .foodAndDrink, type: .expense, spent: 300, total: 400),
            .init(subCategory: .restaurants, type: .expense, spent: 200, total: 250),
            .init(subCategory: .fastFood, type: .expense, spent: 50, total: 100),
            .init(subCategory: .coffeeShop, type: .expense, spent: 40, total: 60),

            // Transportation (10-15%)
            .init(subCategory: .transportation, type: .expense, spent: 200, total: 250),
            .init(subCategory: .taxi, type: .expense, spent: 50, total: 100),

            // Insurance & Healthcare (10-12%)
            .init(subCategory: .insurance, type: .expense, spent: 300, total: 300),
            .init(subCategory: .healthcare, type: .expense, spent: 150, total: 200),

            // Entertainment & Recreation (5-10%)
            .init(subCategory: .entertainment, type: .expense, spent: 100, total: 150),
            .init(subCategory: .recreation, type: .expense, spent: 80, total: 100),
            .init(subCategory: .gymsAndFitnessCenters, type: .expense, spent: 50, total: 50),

            // Shopping & Personal (5-10%)
            .init(subCategory: .shopping, type: .expense, spent: 150, total: 200),
            .init(subCategory: .sportingGoods, type: .expense, spent: 0, total: 100),

            // Debt Payments
            .init(subCategory: .creditCard, type: .expense, spent: 300, total: 300),
            .init(subCategory: .payment, type: .expense, spent: 200, total: 200),

            // Travel & Special
            .init(subCategory: .travel, type: .expense, spent: 200, total: 500),
            .init(subCategory: .airlinesAndAviation, type: .expense, spent: 0, total: 300),

            // Services & Miscellaneous
            .init(subCategory: .service, type: .expense, spent: 100, total: 150),
            .init(subCategory: .general, type: .expense, spent: 50, total: 100),
        ]

        budget = .init(
            month: month,
            incomeCategories: incomeCategories,
            expenseCategories: expenseCategories
        )
    }

    func addCategory(_ category: Budget.BudgetCategory) {
        switch category.type {
        case .income:
            budget.incomeCategories.append(category)
        case .expense:
            budget.expenseCategories.append(category)
        }

        // Recreate budget to recalculate summary
        budget = .init(
            month: budget.month,
            incomeCategories: budget.incomeCategories,
            expenseCategories: budget.expenseCategories
        )
    }

    func updateCategory(_ oldCategory: Budget.BudgetCategory, with newCategory: Budget.BudgetCategory) {
        switch oldCategory.type {
        case .income:
            if let index = budget.incomeCategories.firstIndex(where: { $0.id == oldCategory.id }) {
                budget.incomeCategories[index] = newCategory
            }
        case .expense:
            if let index = budget.expenseCategories.firstIndex(where: { $0.id == oldCategory.id }) {
                budget.expenseCategories[index] = newCategory
            }
        }

        // Recreate budget to recalculate summary
        budget = .init(
            month: budget.month,
            incomeCategories: budget.incomeCategories,
            expenseCategories: budget.expenseCategories
        )
    }
}
