import Inject
import SwiftUI

struct BudgetView: View {
    @ObserveInjection var inject
    @EnvironmentObject var appState: AppState
    @State private var showingNewCategorySheet = false

    var body: some View {
        NavigationStack {
            ViewBuilderWrapper {
                BudgetHeaderView(budgetViewModel: appState.budgetViewModel)
            } main: {
                BudgetMainView(budgetViewModel: appState.budgetViewModel)
            }
            .navigationBarStyle()
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingNewCategorySheet = true
                    } label: {
                        Image(systemName: "plus")
                            .foregroundColor(.white)
                    }
                }
            }
        }
        .sheet(isPresented: $showingNewCategorySheet) {
            AddBudgetCategoryView(viewModel: appState.budgetViewModel)
        }
        .enableInjection()
    }
}

// Supporting Views
struct BudgetHeaderView: View {
    @StateObject var budgetViewModel: BudgetViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 36) {
            VStack(alignment: .leading, spacing: 12) {
                Text("Budget for June")
                    .font(.title)
                    .foregroundColor(.white)
            }
            // Donut View
            BudgetDonutView(budgetViewModel: budgetViewModel)
        }
        .padding([.top, .bottom], 48)
        .padding()
        .frame(maxWidth: .infinity)
        .greenGradientBackground()
    }
}

struct BudgetDonutView: View {
    @ObservedObject var budgetViewModel: BudgetViewModel
    @State private var animateDonut: Bool = false

    var body: some View {
        VStack(alignment: .center, spacing: 24) {
            // Donut Chart
            DonutChart(budget: budgetViewModel.budget, animate: animateDonut)
        }
        .onAppear {
            withAnimation {
                animateDonut = true
            }
        }
    }
}

struct BudgetMainView: View {
    @StateObject var budgetViewModel: BudgetViewModel
    @State private var isIncomeExpanded: Bool = false
    @State private var isExpensesExpanded: Bool = true

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            // Income DisclosureGroup
            DisclosureGroup(
                isExpanded: $isIncomeExpanded,
                content: {
                    LazyVStack(spacing: 16) {
                        ForEach(budgetViewModel.budget.incomeCategories) { category in
                            BudgetCategoryRow(category: category)
                        }
                    }
                },
                label: {
                    HStack {
                        Text(Budget.BudgetType.income.rawValue)
                            .font(.headline)
                            .foregroundColor(.primary)
                        Spacer()
                        Text(budgetViewModel.budget.formattedTotalIncome)
                            .font(.headline)
                            .foregroundColor(.primaryGreen)
                    }
                }
            )

            // Expenses DisclosureGroup with default expanded state
            DisclosureGroup(
                isExpanded: $isExpensesExpanded,
                content: {
                    LazyVStack(spacing: 16) {
                        ForEach(budgetViewModel.budget.expenseCategories) { category in
                            BudgetCategoryRow(category: category)
                        }
                    }
                },
                label: {
                    HStack {
                        Text(Budget.BudgetType.expense.rawValue)
                            .font(.headline)
                            .foregroundColor(.primary)
                        Spacer()
                        Text(budgetViewModel.budget.formattedTotalExpenses)
                            .font(.headline)
                            .foregroundColor(.alertRed)
                    }
                }
            )
        }
        .padding()
    }
}

struct BudgetCategoryRow: View {
    let category: Budget.BudgetCategory
    @State private var animateProgress: Bool = false

    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text(category.subCategory.rawValue)
                    .font(.subheadline)
                Spacer()
                Text(category.getRemaining())
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Button(action: {}) {
                    Image(systemName: "pencil")
                        .foregroundColor(.secondary)
                }
            }

            ProgressBar(
                value: category.getProgress(),
                color: category.color,
                animate: animateProgress
            )

            HStack(spacing: 4) {
                Text("$\(Int(category.spent))")
                    .font(.subheadline.bold())
                Text("of $\(Int(category.total))")
                    .font(.subheadline.bold())
                    .foregroundColor(.secondary)
                Spacer()
            }
        }
        .onAppear {
            withAnimation {
                animateProgress = true
            }
        }
    }
}

#Preview {
    BudgetView()
        .withPreviewEnvironment()
}
