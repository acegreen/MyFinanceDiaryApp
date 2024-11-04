import Inject
import SwiftUI

struct AddBudgetCategoryView: View {
    @Environment(\.dismiss) private var dismiss
    @ObserveInjection var inject
    @ObservedObject var viewModel: BudgetViewModel
    @State private var selectedType: Budget.BudgetType = .expense
    @State private var selectedCategory: TransactionCategory = .general
    @State private var total: String = ""

    var body: some View {
        NavigationView {
            Form {
                Picker("Type", selection: $selectedType) {
                    Text(Budget.BudgetType.income.rawValue)
                        .tag(Budget.BudgetType.income)
                    Text(Budget.BudgetType.expense.rawValue)
                        .tag(Budget.BudgetType.expense)
                }

                Picker("Category", selection: $selectedCategory) {
                    ForEach(TransactionCategory.allCases, id: \.self) { category in
                        Text(category.rawValue)
                            .tag(category)
                    }
                }

                TextField("Budget Amount", text: $total)
                    .keyboardType(.decimalPad)
            }
            .navigationTitle("New Budget Category")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        addCategory()
                    }
                    .disabled(total.isEmpty)
                }
            }
        }
        .enableInjection()
    }

    private func addCategory() {
        guard let totalAmount = Double(total) else { return }

        let newCategory = Budget.BudgetCategory(
            subCategory: selectedCategory,
            type: selectedType,
            spent: 0,
            total: totalAmount
        )

        viewModel.addCategory(newCategory)
        dismiss()
    }
}
