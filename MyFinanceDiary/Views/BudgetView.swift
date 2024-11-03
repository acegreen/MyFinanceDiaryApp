import Inject
import SwiftUI

struct BudgetView: View {
    @ObserveInjection var inject
    @EnvironmentObject var appState: AppState
    @Binding var showMenu: Bool

    var body: some View {
        ViewBuilderWrapper {
            BudgetHeaderView(amount: appState.budgetViewModel.formattedRemaining)
        } main: {
            BudgetMainView()
        }
        .enableInjection()
    }
}

// Supporting Views
struct BudgetHeaderView: View {
    let amount: String
    @EnvironmentObject var appState: AppState

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            VStack(alignment: .leading, spacing: 12) {
                Text("Budget for June")
                    .font(.title)
                    .foregroundColor(.white)

                HStack(alignment: .center) {
                    Text(amount)
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(.white)

                    Text("Left")
                        .font(.subheadline.bold())
                        .foregroundColor(.white)
                        .padding(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(.white, lineWidth: 2)
                        )
                }
            }
            // Progress Bar
            ProgressSection(
                spent: appState.budgetViewModel.budgetSummary.totalSpent,
                total: appState.budgetViewModel.budgetSummary.totalBudget
            )
        }
        .padding(.top, 48)
        .padding()
        .greenGradientBackground()
    }

    struct ProgressSection: View {
        let spent: Double
        let total: Double

        var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                ProgressBar(value: spent / total, height: 16)
                HStack(spacing: 4) {
                    Text("$\(Int(spent))")
                        .font(.headline.bold())
                    Text("of $\(Int(total))")
                        .font(.headline)
                    Spacer()
                }
                .foregroundColor(.white)
            }
        }
    }
}

struct BudgetMainView: View {
    @ObserveInjection var inject
    @EnvironmentObject var appState: AppState

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            BudgetExpandableSection(
                title: "Income",
                amount: appState.budgetViewModel.formattedTotalIncome,
                amountColor: .primaryGreen,
                categories: appState.budgetViewModel.incomeCategories
            )
            BudgetExpandableSection(
                title: "Expenses",
                amount: appState.budgetViewModel.formattedTotalExpenses,
                amountColor: .alertRed,
                categories: appState.budgetViewModel.expenseCategories,
                expandedByDefault: true
            )
        }
        .padding()
    }
}

struct BudgetExpandableSection: View {
    let title: String
    let amount: String
    let amountColor: Color
    let categories: [Budget.BudgetCategory]
    @State private var isExpanded: Bool

    // Add initializer to set default state
    init(title: String, amount: String, amountColor: Color, categories: [Budget.BudgetCategory], expandedByDefault: Bool = false) {
        self.title = title
        self.amount = amount
        self.amountColor = amountColor
        self.categories = categories
        _isExpanded = State(initialValue: expandedByDefault)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header
            Button(action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                    isExpanded.toggle()
                }
            }) {
                HStack {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.primary)
                    Spacer()
                    Text(amount)
                        .font(.headline)
                        .foregroundColor(amountColor)
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.secondary)
                        .animation(nil) // Prevent chevron animation glitch
                }
            }

            if isExpanded {
                LazyVStack(spacing: 16) {
                    ForEach(categories) { category in
                        BudgetCategoryRow(category: category)
                    }
                }
            }
        }
    }
}

struct BudgetCategoryRow: View {
    let category: Budget.BudgetCategory
    @EnvironmentObject var appState: AppState

    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text(category.name)
                    .font(.subheadline)
                Spacer()
                Text(appState.budgetViewModel.getRemainingAmount(for: category))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Button(action: {}) {
                    Image(systemName: "pencil")
                        .foregroundColor(.secondary)
                }
            }

            ProgressBar(value: appState.budgetViewModel.getProgress(for: category), color: category.color)

            HStack(spacing: 4) {
                Text("$\(Int(category.spent))")
                    .font(.subheadline.bold())
                Text("of $\(Int(category.total))")
                    .font(.subheadline.bold())
                    .foregroundColor(.secondary)
                Spacer()
            }
        }
    }
}

#Preview {
    BudgetView(showMenu: .constant(false))
        .withPreviewEnvironment()
}
