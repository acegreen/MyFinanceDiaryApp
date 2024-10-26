import SwiftUI
import Inject

struct FilterSortView: View {
    @ObserveInjection var inject
    @Binding var selectedCategory: RecurringPurchase.Category
    @Binding var selectedFrequency: RecurringPurchase.Frequency
    @Binding var selectedSortOption: RecurringPurchase.SortOption
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Filter by Category")) {
                    Picker("Category", selection: $selectedCategory) {
                        ForEach(RecurringPurchase.Category.allCases, id: \.self) { category in
                            Text(category.displayName)
                        }
                    }
                    .pickerStyle(DefaultPickerStyle())
                }
                
                Section(header: Text("Filter by Frequency")) {
                    Picker("Frequency", selection: $selectedFrequency) {
                        ForEach(RecurringPurchase.Frequency.allCases, id: \.self) { frequency in
                            Text(frequency.displayName)
                        }
                    }
                    .pickerStyle(DefaultPickerStyle())
                }

                Section(header: Text("Sort By")) {
                    Picker("Sort Option", selection: $selectedSortOption) {
                        ForEach(RecurringPurchase.SortOption.allCases, id: \.self) { option in
                            Text(option.rawValue)
                        }
                    }
                    .pickerStyle(DefaultPickerStyle())
                }
            }
            .navigationTitle("Filter & Sort")
            .navigationBarItems(trailing: Button("Done") {
                dismiss()
            })
            .tint(.greenAce)
        }
        .enableInjection()
    }
}

#Preview {
    FilterSortView(
        selectedCategory: .constant(.all),
        selectedFrequency: .constant(.all),
        selectedSortOption: .constant(.nameAsc)
    )
    .withPreviewEnvironment()
}
