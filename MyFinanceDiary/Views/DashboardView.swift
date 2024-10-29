import SwiftUI
import Charts
import Inject

struct DashboardView: View {
    @ObserveInjection var inject
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        ViewBuilderWrapper {
            DashboardHeaderView(dashboardViewModel: appState.dashboardViewModel)
        } main: {
            AccountsSection(accounts: appState.dashboardViewModel.accounts, dashboardViewModel: appState.dashboardViewModel)
                .background(Color("AccentColor").opacity(0.05))
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
    }
}

// Separate Accounts Section
struct AccountsSection: View {
    let accounts: [Account]
    @ObservedObject var dashboardViewModel: DashboardViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            AccountsList(accounts: accounts, dashboardViewModel: dashboardViewModel)
        }
        .background(Color(uiColor: .systemBackground))
    }
}

// Separate Accounts List
struct AccountsList: View {
    let accounts: [Account]
    @ObservedObject var dashboardViewModel: DashboardViewModel

    var body: some View {
        VStack(spacing: 16) {
            ForEach(accounts) { account in
                AccountItemRow(
                    type: account.type,
                    amount: dashboardViewModel.formatAmount(account.amount)
                )
            }
        }
        .padding(.horizontal)
    }
}

struct DashboardHeaderView: View {
    @ObservedObject var dashboardViewModel: DashboardViewModel
    @State private var showingCreditScore = false

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Credit Score Section
            Button(action: {
                showingCreditScore = true
            }) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Credit score")
                            .font(.headline)
                            .foregroundColor(.white.opacity(0.9))
                        Text("\(dashboardViewModel.creditScore)")
                            .font(.title2.bold())
                            .foregroundColor(.white)
                    }
                    Spacer()
                }
            }
            .buttonStyle(PlainButtonStyle()) // Prevents default button styling

            // Tab Selection
            Picker("View Selection", selection: $dashboardViewModel.selectedSegment) {
                ForEach(DashboardViewModel.ChartSegment.allCases, id: \.self) { tab in
                    Text(tab.rawValue)
                        .tag(tab)
                }
            }
            .pickerStyle(.segmented)
            .colorScheme(.dark) // Force dark mode for white text

            // Amount Display
            VStack(alignment: .leading, spacing: 8) {
                Text(dashboardViewModel.currentAmount)
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(.white)

                HStack(spacing: 4) {
                    Image(systemName: dashboardViewModel.changeIsPositive ? "arrow.up" : "arrow.down")
                        .foregroundColor(dashboardViewModel.changeIsPositive ? .green : .red)
                    Text(dashboardViewModel.changeDescription)
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.9))
                }
            }
            .padding(.top, 8)

            // Chart
            FinancialChartView(data: dashboardViewModel.chartData)
        }
        .padding(24)
        .padding(.top, 48)
        .background(
            LinearGradient(
                colors: [Color(hex: "1D7B6E"), Color(hex: "1A9882")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .sheet(isPresented: $showingCreditScore) {
            CreditScoreView()
        }
    }
}


// FinancialItemView for each financial category
struct AccountItemRow: View {
    var type: Account.AccountType
    var amount: String
    
    var body: some View {
        NavigationLink(destination: TransactionsView(accountType: type)) {
            HStack {
                Text(type.rawValue)
                    .font(.system(size: 17))
                    .foregroundColor(.primary)
                Spacer()
                Text(amount)
                    .font(.system(size: 17, weight: .medium))
                    .foregroundColor(amount.contains("-") ? .red : .green)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16) // Increase vertical padding
            .background(Color(uiColor: .systemBackground))
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
        }
    }
}

#Preview {
    DashboardView()
        .withPreviewEnvironment()
}
