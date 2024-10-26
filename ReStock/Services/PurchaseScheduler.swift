import Foundation

class PurchaseScheduler {
    static func updateNextPurchaseDate(for purchase: RecurringPurchase) {
        let calendar = Calendar.current
        let today = Date()
        
        purchase.nextPurchaseDate = calendar.date(byAdding: purchase.frequency.calendarComponent, value: purchase.frequency.value, to: today)
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
