import Inject
import SwiftUI

struct InsightsView: View {
    @ObserveInjection var inject
    @EnvironmentObject var appState: AppState
    @Binding var showMenu: Bool

    var body: some View {
        ViewBuilderWrapper {
            InsightsHeaderView()
        } main: {
            InsightsMainView()
        }
        .enableInjection()
    }
}

struct InsightsHeaderView: View {
    var body: some View {
        // Monthly Spending Donut Chart
        EmptyView()
        .padding(.top, 48)
        .padding()
        .greenGradientBackground()
    }
}

struct InsightsMainView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Cashflow Overview Cards
                VStack(spacing: 16) {
                    CashflowCard(
                        title: "My Cashflow for June",
                        earned: 3000,
                        spent: 2106,
                        remaining: 24578
                    )

                    CashflowTrendCard(
                        title: "My Cashflow for June",
                        currentAmount: 2878.90,
                        cryptoValues: [
                            .init(label: "ETH", value: "0.9087"),
                            .init(label: "BTC", value: "0.5"),
                        ]
                    )
                }

                // Bills Section
                UpcomingBillsCard(bills: [
                    .init(date: "JUN 1", title: "Rent", amount: 1100, isPaid: true),
                    .init(date: "JUN 15", title: "LADWP", amount: 34, isPaid: false),
                    .init(date: "AUG 30", title: "State Farm", amount: 108, isPaid: false),
                ])

                // Financial Habits Grid
                FinancialHabitsGrid(habits: [
                    .init(title: "LYFT Savings", progress: 0.6, current: 60, target: 100, daysLeft: 12),
                    .init(title: "Gas", progress: 0.23, current: 23, target: 100, daysLeft: 15),
                    .init(title: "Travel", progress: 0.6, current: 60, target: 100, daysLeft: 12),
                ])

                // Bottom Cards
                VStack(spacing: 16) {
                    GoalsStorageCard(
                        saved: 4200,
                        target: 6000
                    )

                    InvestmentCard(
                        amount: 30,
                        description: "invested since your last login"
                    )

                    LoansCard(
                        amount: 430,
                        description: "paid towards loans since your last login",
                        remainingText: "YOU STILL OWE $150,000"
                    )
                }
            }
            .padding()
        }
    }
}

struct CashflowCard: View {
    let title: String
    let earned: Double
    let spent: Double
    let remaining: Double

    var body: some View {
        CardView {
            VStack(alignment: .leading) {
                // Implementation
            }
        }
    }
}

struct CashflowTrendCard: View {
    @ObserveInjection var inject

    let title: String
    let currentAmount: Double
    let cryptoValues: [CryptoValue]

    var body: some View {
        CardView {
            VStack(alignment: .leading, spacing: 12) {
                Text(title)
                    .font(.headline)

                // Line Chart would go here
                Rectangle()
                    .fill(Color.darkGreen.opacity(0.3))
                    .frame(height: 100)
                    .overlay(
                        Path { _ in
                            // Placeholder for actual chart
                        }
                        .stroke(Color.darkGreen, lineWidth: 2)
                    )

                Text("$\(String(format: "%.2f", currentAmount))")
                    .font(.title2)
                    .bold()

                HStack {
                    ForEach(cryptoValues, id: \.label) { crypto in
                        Text("\(crypto.value) \(crypto.label)")
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.darkGreen.opacity(0.2))
                            .cornerRadius(8)
                    }
                }
            }
            .padding()
        }
    }
}

struct UpcomingBillsCard: View {
    @ObserveInjection var inject

    let bills: [BillItem]

    var body: some View {
        CardView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Upcoming Bills")
                    .font(.headline)

                ForEach(bills, id: \.title) { bill in
                    HStack {
                        Text(bill.date)
                            .foregroundColor(.secondary)

                        Text(bill.title)

                        Spacer()

                        Text("$\(String(format: "%.2f", bill.amount))")
                            .bold()

                        if bill.isPaid {
                            Text("PAID")
                                .foregroundColor(.green)
                                .font(.caption)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.green.opacity(0.2))
                                .cornerRadius(8)
                        }
                    }
                    Divider()
                }
            }
            .padding()
        }
    }
}

struct FinancialHabitsGrid: View {
    @ObserveInjection var inject

    let habits: [FinancialHabit]

    var body: some View {
        CardView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Improving Financial Habits")
                    .font(.headline)

                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                ], spacing: 16) {
                    ForEach(habits, id: \.title) { habit in
                        HabitCell(habit: habit)
                    }
                }
            }
            .padding()
        }
    }
}

struct HabitCell: View {
    let habit: FinancialHabit

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(habit.title)
                .font(.subheadline)

            ProgressBar(value: habit.progress, color: .darkGreen)

            Text("$\(habit.current)/$\(habit.target)")
                .font(.headline)

            Text("\(habit.daysLeft) days left")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
}

struct GoalsStorageCard: View {
    @ObserveInjection var inject

    let saved: Double
    let target: Double

    var progress: Double {
        saved / target
    }

    var body: some View {
        CardView {
            VStack(alignment: .leading, spacing: 12) {
                Text("Stored For Goals")
                    .font(.headline)

                CircularProgressView(progress: progress)
                    .frame(height: 60)

                Text("$\(Int(saved))/$\(Int(target))")
                    .font(.subheadline)
                    .bold()
            }
            .padding()
        }
    }
}

struct InvestmentCard: View {
    @ObserveInjection var inject

    let amount: Double
    let description: String

    var body: some View {
        CardView {
            VStack(alignment: .leading, spacing: 12) {
                Text("$\(Int(amount))")
                    .font(.title2)
                    .bold()

                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding()
        }
    }
}

struct LoansCard: View {
    @ObserveInjection var inject

    let amount: Double
    let description: String
    let remainingText: String

    var body: some View {
        CardView {
            VStack(alignment: .leading, spacing: 12) {
                Text("$\(Int(amount))")
                    .font(.title2)
                    .bold()

                Text(description)
                    .font(.headline)
                    .foregroundColor(.secondary)

                Text(remainingText)
                    .font(.subheadline)
                    .foregroundColor(.red)
            }
            .padding()
        }
    }
}

// Models

struct FinancialHabit {
    let title: String
    let progress: Double
    let current: Int
    let target: Int
    let daysLeft: Int
}

struct CryptoValue {
    let label: String
    let value: String
}

#Preview {
    InsightsView(showMenu: .constant(false))
        .withPreviewEnvironment()
}
