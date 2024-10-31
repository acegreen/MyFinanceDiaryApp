import Foundation

struct DashboardAccount: Identifiable {
    var id: idType
    var value: Double

    enum idType: String {
        case cash = "Cash"
        case creditCards = "Credit Cards"
        case investments = "Investments"
        case property = "Property"
    }

    var isNegative: Bool {
        return value < 0
    }

    func toAccountTypes() -> [AccountType] {
        switch id {
        case .cash:
            return [.depository]
        case .creditCards:
            return [.credit]
        case .investments:
            return [.investment]
        case .property:
            return [.loan]
        @unknown default:
            return [.unknown]
        }
    }

    func toAccountSubtypes() -> [AccountSubtype] {
        switch id {
        case .cash:
            return [.checking, .savings, .cd, .moneyMarket, .hsa, .cashManagement]
        case .creditCards:
            return [.creditCard, .businessCreditCard]
        case .investments:
            return [.ira, .k401]
        case .property:
            return [.mortgage]
        @unknown default:
            return [.unknown]
        }
    }
}
