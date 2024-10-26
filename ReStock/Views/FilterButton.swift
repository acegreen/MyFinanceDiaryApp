import SwiftUI
import Inject

struct FilterButton: View {
    @ObserveInjection var inject
    let title: String
    let filter: PurchaseFilter
    @Binding var selectedFilter: PurchaseFilter

    enum PurchaseFilter: Equatable {
        case all
        case category(RecurringPurchase.Category)
        case frequency(RecurringPurchase.Frequency)
    }

    var body: some View {
        Button(action: {
            selectedFilter = filter
        }) {
            Text(title)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(selectedFilter == filter ? .greenAce : Color.clear)
                .foregroundColor(selectedFilter == filter ? .white : .primary)
                .cornerRadius(20)
        }
        .enableInjection()
    }
}

// Extension to get the title for each filter
extension FilterButton.PurchaseFilter {
    var title: String {
        switch self {
        case .all:
            return "All"
        case .frequency(let freq):
            return freq.rawValue.capitalized
        case .category(let cat):
            return cat.rawValue.capitalized
        }
    }
}

// Make FilterButton.PurchaseFilter conform to Hashable
extension FilterButton.PurchaseFilter: Hashable {
    func hash(into hasher: inout Hasher) {
        switch self {
        case .all:
            hasher.combine(0)
        case .frequency(let freq):
            hasher.combine(1)
            hasher.combine(freq)
        case .category(let cat):
            hasher.combine(2)
            hasher.combine(cat)
        }
    }
}

#Preview {
    FilterButton(title: "All", filter: .all, selectedFilter: .constant(.all))
}
