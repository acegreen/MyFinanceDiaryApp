import Inject
import SwiftUI

struct BudgetView: View {
    @ObserveInjection var inject
    @EnvironmentObject var appState: AppState
    @Binding var showMenu: Bool

    var body: some View {
        ViewBuilderWrapper {
            BudgetHeaderView(budget: appState.budgetViewModel.budget)
        } main: {
            BudgetMainView(budget: appState.budgetViewModel.budget)
        }
        .enableInjection()
    }
}

// Supporting Views
struct BudgetHeaderView: View {
    let budget: Budget

    var body: some View {
        VStack(alignment: .leading, spacing: 36) {
            VStack(alignment: .leading, spacing: 12) {
                Text("Budget for June")
                    .font(.title)
                    .foregroundColor(.white)
            }
            // Donut View
            BudgetDonutView(budget: budget)
        }
        .padding([.top, .bottom], 48)
        .padding()
        .frame(maxWidth: .infinity)
        .greenGradientBackground()
    }
}

struct BudgetDonutView: View {
    let budget: Budget
    @State private var animateDonut: Bool = false

    var body: some View {
        VStack(alignment: .center, spacing: 24) {
            // Donut Chart
            DonutChart(budget: budget, animate: animateDonut)
        }
        .onAppear {
            withAnimation {
                animateDonut = true
            }
        }
    }
}

struct BudgetMainView: View {
    let budget: Budget
    @State private var isIncomeExpanded: Bool = false
    @State private var isExpensesExpanded: Bool = true

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            // Income DisclosureGroup
            DisclosureGroup(
                isExpanded: $isIncomeExpanded,
                content: {
                    LazyVStack(spacing: 16) {
                        ForEach(budget.incomeCategories) { category in
                            BudgetCategoryRow(category: category)
                        }
                    }
                },
                label: {
                    HStack {
                        Text("Income")
                            .font(.headline)
                            .foregroundColor(.primary)
                        Spacer()
                        Text(budget.formattedTotalIncome)
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
                        ForEach(budget.expenseCategories) { category in
                            BudgetCategoryRow(category: category)
                        }
                    }
                },
                label: {
                    HStack {
                        Text("Expenses")
                            .font(.headline)
                            .foregroundColor(.primary)
                        Spacer()
                        Text(budget.formattedTotalExpenses)
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
                Text(category.category.rawValue)
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
    BudgetView(showMenu: .constant(false))
        .withPreviewEnvironment()
}
