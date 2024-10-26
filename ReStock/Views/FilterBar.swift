import SwiftUI
import Inject

struct FilterBar: View {
    @ObserveInjection var inject
    @Binding var selectedFilter: FilterButton.PurchaseFilter
    
    private let filters: [FilterButton.PurchaseFilter] = [
        .all,
        .frequency(.weekly),
        .frequency(.monthly),
        .frequency(.quarterly),
        .frequency(.yearly)
    ]
    
    var body: some View {
        Picker("Filter", selection: $selectedFilter) {
            ForEach(filters, id: \.self) { filter in
                Text(filter.title)
                    .tag(filter)
            }
        }
        .pickerStyle(.segmented)
        .padding(.horizontal)
        .cornerRadius(8)
        .enableInjection()
    }
}

#Preview {
    FilterBar(selectedFilter: .constant(.all))
        .withPreviewEnvironment()
}
