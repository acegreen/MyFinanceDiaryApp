import Foundation

struct Bill: Identifiable {
    let id = UUID()
    let title: String
    let amount: Double
    let dueDate: String
}

enum BillSegment: String, CaseIterable {
    case bills = "Bills"
    case subscriptions = "Subscriptions"
}
