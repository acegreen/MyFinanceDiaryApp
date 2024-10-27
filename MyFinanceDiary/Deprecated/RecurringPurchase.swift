import Foundation
import SwiftData

@Model
final class RecurringPurchase {

    enum Category: String, CaseIterable {
        case all, groceries, household, personalCare, petSupplies, other

        var displayName: String {
            rawValue.capitalized
        }

        var categoryIcon: String {
            switch self {
            case .all:
                return "asterisk"
            case .groceries:
                return "cart"
            case .personalCare:
                return "heart"
            case .petSupplies:
                return "pawprint"
            case .household:
                return "house"
            case .other:
                return "square.grid.2x2"
            }
        }

        func matches(_ category: Category) -> Bool {
            self == .all || self == category
        }
    }

    enum Frequency: String, CaseIterable {
        case all, daily, weekly, biweekly, monthly, quarterly, yearly

        var displayName: String {
            rawValue.capitalized
        }

        var shortName: String {
            switch self {
            case .all: return "All"
            case .daily: return "D"
            case .weekly: return "W"
            case .biweekly: return "Bi-W"
            case .monthly: return "M"
            case .quarterly: return "Q"
            case .yearly: return "Y"
            }
        }

        func matches(_ frequency: Frequency) -> Bool {
            self == .all || self == frequency
        }
    }

    enum SortOption: String, CaseIterable {
        case nameAsc = "Name (A-Z)"
        case nameDesc = "Name (Z-A)"
        case dateAsc = "Date (Oldest First)"
        case dateDesc = "Date (Newest First)"
        case priceAsc = "Price (Low to High)"
        case priceDesc = "Price (High to Low)"
    }

    var category: Category {
        get { Category(rawValue: categoryRawValue) ?? .other }
        set { categoryRawValue = newValue.rawValue }
    }

    var frequency: Frequency {
        get { Frequency(rawValue: frequencyRawValue) ?? .weekly }
        set { frequencyRawValue = newValue.rawValue }
    }

    var provider: OrderingService.Provider {
        get { OrderingService.Provider(rawValue: providerRawValue) ?? .amazon }
        set { providerRawValue = newValue.rawValue }
    }

    // Computed property for total price
    var totalPrice: Decimal {
        return price * Decimal(quantity)
    }

    var name: String
    var categoryRawValue: String
    var frequencyRawValue: String
    var quantity: Int
    var autoOrder: Bool
    var notifyBeforeShipping: Bool
    var notes: String
    var nextPurchaseDate: Date?
    var price: Decimal
    var providerRawValue: String

    init(name: String = "",
         category: Category = .groceries,
         frequency: Frequency = .weekly,
         quantity: Int = 1,
         autoOrder: Bool = false,
         notifyBeforeShipping: Bool = false,
         notes: String = "",
         nextPurchaseDate: Date? = nil,
         price: Decimal = 0.0,
         provider: OrderingService.Provider = .amazon) {
        self.name = name
        self.categoryRawValue = category.rawValue
        self.frequencyRawValue = frequency.rawValue
        self.quantity = quantity
        self.autoOrder = autoOrder
        self.notifyBeforeShipping = notifyBeforeShipping
        self.notes = notes
        self.nextPurchaseDate = nextPurchaseDate
        self.price = price
        self.providerRawValue = provider.rawValue
    }
}

extension RecurringPurchase.Frequency {
    var calendarComponent: Calendar.Component {
        switch self {
        case .daily: return .day
        case .weekly, .biweekly: return .weekOfYear
        case .monthly, .quarterly: return .month
        case .yearly: return .year
        case .all: return .day // Default case, though it won't be used
        }
    }
    
    var value: Int {
        switch self {
        case .daily: return 1
        case .weekly: return 1
        case .biweekly: return 2
        case .monthly: return 1
        case .quarterly: return 3
        case .yearly: return 1
        case .all: return 0 // Default case, though it won't be used
        }
    }
}

extension RecurringPurchase: Equatable {
    static func == (lhs: RecurringPurchase, rhs: RecurringPurchase) -> Bool {
        lhs.id == rhs.id
    }
}
