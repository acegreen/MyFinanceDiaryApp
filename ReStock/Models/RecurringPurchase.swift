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

    var name: String
    var categoryRawValue: String
    var frequencyRawValue: String
    var quantity: Int
    var autoOrder: Bool
    var notifyBeforeShipping: Bool
    var notes: String
    var nextPurchaseDate: Date?
    var price: Decimal

    init(name: String = "",
         category: Category = .groceries,
         frequency: Frequency = .weekly,
         quantity: Int = 1,
         autoOrder: Bool = false,
         notifyBeforeShipping: Bool = false,
         notes: String = "",
         nextPurchaseDate: Date? = nil,
         price: Decimal = 0.0) {
        self.name = name
        self.categoryRawValue = category.rawValue
        self.frequencyRawValue = frequency.rawValue
        self.quantity = quantity
        self.autoOrder = autoOrder
        self.notifyBeforeShipping = notifyBeforeShipping
        self.notes = notes
        self.nextPurchaseDate = nextPurchaseDate
        self.price = price
    }

    var category: Category {
        get { Category(rawValue: categoryRawValue) ?? .other }
        set { categoryRawValue = newValue.rawValue }
    }

    var frequency: Frequency {
        get { Frequency(rawValue: frequencyRawValue) ?? .weekly }
        set { frequencyRawValue = newValue.rawValue }
    }

    // Computed property for total price
    var totalPrice: Decimal {
        return price * Decimal(quantity)
    }
}

extension RecurringPurchase: Equatable {
    static func == (lhs: RecurringPurchase, rhs: RecurringPurchase) -> Bool {
        lhs.id == rhs.id
    }
}
