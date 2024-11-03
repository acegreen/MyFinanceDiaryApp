import Foundation

struct Bill: Identifiable {
    let id = UUID()
    let title: String
    let amount: Double
    let dueDate: String
}

struct BillItem {
    let date: String
    let title: String
    let amount: Double
    let isPaid: Bool
}

enum BillSegment: String, CaseIterable {
    case bills = "Bills"
    case subscriptions = "Subscriptions"
}
