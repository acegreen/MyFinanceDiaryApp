import Foundation

class PurchaseScheduler {
    static func updateNextPurchaseDate(for purchase: RecurringPurchase) {
        let calendar = Calendar.current
        let today = Date()
        
        purchase.nextPurchaseDate = calendar.date(byAdding: purchase.frequency.calendarComponent, value: purchase.frequency.value, to: today)
    }
}
