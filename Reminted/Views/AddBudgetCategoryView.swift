import Inject
import SwiftUI

struct AddBudgetCategoryView: View {
    @Environment(\.dismiss) private var dismiss
    @ObserveInjection var inject
    @ObservedObject var viewModel: BudgetViewModel
    let editingCategory: Budget.BudgetCategory?

    @State private var selectedType: Budget.BudgetType
    @State private var selectedCategory: TransactionCategory
    @State private var total: String

    init(viewModel: BudgetViewModel, editingCategory: Budget.BudgetCategory? = nil) {
        self.viewModel = viewModel
        self.editingCategory = editingCategory

        _selectedType = State(initialValue: editingCategory?.type ?? .expense)
        _selectedCategory = State(initialValue: editingCategory?.subCategory ?? .general)
        _total = State(initialValue: editingCategory != nil ? String(editingCategory!.total) : "")
    }

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
            .navigationTitle(editingCategory != nil ? "Edit Budget Category" : "New Budget Category")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(editingCategory != nil ? "Save" : "Add") {
                        saveCategory()
                    }
                    .disabled(total.isEmpty)
                }
            }
        }
        .enableInjection()
    }

    private func saveCategory() {
        guard let totalAmount = Double(total) else { return }

        let category = Budget.BudgetCategory(
            subCategory: selectedCategory,
            type: selectedType,
            spent: editingCategory?.spent ?? 0,
            total: totalAmount
        )

        if let editingCategory = editingCategory {
            viewModel.updateCategory(editingCategory, with: category)
        } else {
            viewModel.addCategory(category)
        }
        dismiss()
    }
}
