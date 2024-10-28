import SwiftUI
import Inject

struct BudgetView: View {
    @ObserveInjection var inject
    @EnvironmentObject var budgetViewModel: BudgetViewModel

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    VStack {
                        // Header
                        BudgetHeaderView(amount: budgetViewModel.formattedRemaining)
                    }

                    // Categories
                    VStack(alignment: .leading, spacing: 16) {
                        BudgetExpandableSection(
                            title: "Income",
                            amount: budgetViewModel.formattedTotalIncome,
                            amountColor: .green,
                            categories: budgetViewModel.incomeCategories
                        )
                        BudgetExpandableSection(
                            title: "Expenses",
                            amount: budgetViewModel.formattedTotalExpenses,
                            amountColor: .primary,
                            categories: budgetViewModel.expenseCategories,
                            expandedByDefault: true
                        )
                    }
                    .padding(.horizontal)
                }
            }
            .ignoresSafeArea()
            .navigationTitle("\(budgetViewModel.currentMonth) budgets")
            .navigationBarItems(
                trailing: HStack {
                    Button(action: {}) {
                        Image(systemName: "bubble.and.pencil")
                            .foregroundColor(.white)
                    }
                    Button(action: {}) {
                        Image(systemName: "plus")
                            .foregroundColor(.white)
                    }
                }
            )
            .navigationBarTitleDisplayMode(.inline)
        }
        // .preferredColorScheme(.dark)
        .enableInjection()
    }
}

// Supporting Views
struct BudgetHeaderView: View {
    let amount: String
    @EnvironmentObject var budgetViewModel: BudgetViewModel

    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center) {
                Text(amount)
                    .font(.system(size: 48, weight: .bold))
                    .foregroundColor(.white)

                Text("Left")
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .padding(8)
                    .background(Color.gray.opacity(0.3))
                    .border(.white)
                    .cornerRadius(4)
            }

            // Progress Bar
            ProgressSection(
                spent: budgetViewModel.budgetSummary.totalSpent,
                total: budgetViewModel.budgetSummary.totalBudget
            )
        }
        .padding(.top, 48)
        .padding(.horizontal)
        .frame(height: 300)
        .background(
            LinearGradient(
                colors: [Color(hex: "1D7B6E"), Color(hex: "1A9882")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
    }

    struct ProgressSection: View {
        let spent: Double
        let total: Double

        var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                ProgressBar(progress: spent / total, height: 12)
                Text("$\(Int(spent)) of $\(Int(total)) spent")
                    .font(.subheadline)
                    .foregroundColor(.white)
            }
        }
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
                        BudgetCategoryRowView(category: category)
                    }
                }
            }
        }
    }
}

struct BudgetCategoryRowView: View {
    let category: Budget.BudgetCategory
    @EnvironmentObject var budgetViewModel: BudgetViewModel

    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text(category.name)
                    .font(.subheadline)
                Spacer()
                Text(budgetViewModel.getRemainingAmount(for: category))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Button(action: {}) {
                    Image(systemName: "pencil")
                        .foregroundColor(.secondary)
                }
            }

            ProgressBar(progress: budgetViewModel.getProgress(for: category))

            HStack {
                Text("$\(Int(category.spent))")
                    .font(.caption)
                Text("of $\(Int(category.total))")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
            }
        }
    }
}
