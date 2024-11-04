import SwiftUI

@MainActor
class BudgetViewModel: ObservableObject {
    @Published var budget: Budget

    init() {
        // Initialize budgetSummary with all required parameters
        budget = .init(month: "June",
                       incomeCategories: [
                           .init(category: .payroll, spent: 5000, total: 5000),
                           .init(category: .deposit, spent: 200, total: 200),
                       ],
                       expenseCategories: [
                           // Housing & Utilities (30-35% of income)
                           .init(category: .rent, spent: 1600, total: 1800),
                           .init(category: .utilities, spent: 150, total: 200),

                           // Food & Dining (10-15%)
                           .init(category: .foodAndDrink, spent: 300, total: 400),
                           .init(category: .restaurants, spent: 200, total: 250),
                           .init(category: .fastFood, spent: 50, total: 100),
                           .init(category: .coffeeShop, spent: 40, total: 60),

                           // Transportation (10-15%)
                           .init(category: .transportation, spent: 200, total: 250),
                           .init(category: .taxi, spent: 50, total: 100),

                           // Insurance & Healthcare (10-12%)
                           .init(category: .insurance, spent: 300, total: 300),
                           .init(category: .healthcare, spent: 150, total: 200),

                           // Entertainment & Recreation (5-10%)
                           .init(category: .entertainment, spent: 100, total: 150),
                           .init(category: .recreation, spent: 80, total: 100),
                           .init(category: .gymsAndFitnessCenters, spent: 50, total: 50),

                           // Shopping & Personal (5-10%)
                           .init(category: .shopping, spent: 150, total: 200),
                           .init(category: .sportingGoods, spent: 0, total: 100),

                           // Debt Payments
                           .init(category: .creditCard, spent: 300, total: 300),
                           .init(category: .payment, spent: 200, total: 200),

                           // Travel & Special
                           .init(category: .travel, spent: 200, total: 500),
                           .init(category: .airlinesAndAviation, spent: 0, total: 300),

                           // Services & Miscellaneous
                           .init(category: .service, spent: 100, total: 150),
                           .init(category: .general, spent: 50, total: 100),
                       ])
    }
}
