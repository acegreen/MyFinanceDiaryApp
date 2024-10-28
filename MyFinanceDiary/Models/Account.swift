import Foundation

struct Account: Identifiable {

    enum AccountType: String, CaseIterable {
        case cash = "Cash"
        case creditCards = "Credit Cards"
        case investments = "Investments"
        case property = "Property"
        case savings = "Savings"
        case retirement = "Retirement"
        case other = "Other"

        var displayName: String {
            return self.rawValue
        }
    }

    let id = UUID()
    let type: AccountType
    let amount: Double
}
