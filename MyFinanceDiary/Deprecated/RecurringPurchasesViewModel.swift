import SwiftUI
import SwiftData
import Foundation

class RecurringPurchasesViewModel: ObservableObject {
    @Published var purchases: [RecurringPurchase] = []
    
    func filterPurchases(category: RecurringPurchase.Category?, frequency: RecurringPurchase.Frequency?) -> [RecurringPurchase] {
        purchases.filter { purchase in
            (category == nil || purchase.category == category) &&
            (frequency == nil || purchase.frequency == frequency)
        }
    }
}
