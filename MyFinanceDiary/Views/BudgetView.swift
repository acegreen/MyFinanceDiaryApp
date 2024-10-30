import SwiftUI
import Inject

struct BudgetView: View {
    @ObserveInjection var inject
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        ViewBuilderWrapper {
            BudgetHeaderView(amount: appState.budgetViewModel.formattedRemaining)
        } main: {
            BudgetMainView()
        } toolbarContent: {
            Button(action: {}) {
                Image(systemName: "bubble.and.pencil")
                    .foregroundColor(.white)
            }
            Button(action: {}) {
                Image(systemName: "plus")
                    .foregroundColor(.white)
            }
        }
        .navigationTitle("\(appState.budgetViewModel.currentMonth) budgets")
        .navigationBarTitleDisplayMode(.inline)
        .enableInjection()
    }
}

// Supporting Views
struct BudgetHeaderView: View {
    let amount: String
    @EnvironmentObject var appState: AppState

    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center) {
                Text(amount)
                    .font(.system(size: 48, weight: .bold))
                    .foregroundColor(.white)

                Text("Left")
                    .font(.subheadline.bold())
                    .foregroundColor(.white)
                    .padding(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(.white, lineWidth: 2)
                    )
            }

            // Progress Bar
            ProgressSection(
                spent: appState.budgetViewModel.budgetSummary.totalSpent,
                total: appState.budgetViewModel.budgetSummary.totalBudget
            )
        }
        .padding(.top, 48)
        .padding(.horizontal)
        .frame(maxWidth: .infinity, minHeight: 300)
        .greenGradientBackground()
    }

    struct ProgressSection: View {
        let spent: Double
        let total: Double

        var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                ProgressBar(progress: spent / total, height: 12)
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
        .padding(.horizontal)
        .enableInjection()
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

            ProgressBar(progress: appState.budgetViewModel.getProgress(for: category), color: category.color)

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
