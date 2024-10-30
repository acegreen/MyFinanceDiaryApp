import SwiftUI
import Charts
import Inject

struct DashboardView: View {
    @ObserveInjection var inject
    @EnvironmentObject var appState: AppState
    @State private var showMenu: Bool = false
    
    var body: some View {
        ViewBuilderWrapper {
            DashboardHeaderView(dashboardViewModel: appState.dashboardViewModel)
        } main: {
            DashboardMainView(accounts: appState.dashboardViewModel.accounts, dashboardViewModel: appState.dashboardViewModel)
        } toolbarContent: {
            Button(action: {
                showMenu.toggle()
            }) {
                Image(systemName: "line.3.horizontal")
                    .foregroundColor(.white)
            }
            .popoverSheet(isPresented: $showMenu) {
                MenuView()
            }
        }
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
            .padding(.horizontal)
            .buttonStyle(PlainButtonStyle()) // Prevents default button styling

            // Tab Selection
            Picker("View Selection", selection: $dashboardViewModel.selectedSegment) {
                ForEach(DashboardViewModel.ChartSegment.allCases, id: \.self) { tab in
                    Text(tab.rawValue)
                        .tag(tab)
                }
            }
            .padding(.horizontal)
            .pickerStyle(.segmented)
            .colorScheme(.dark) // Force dark mode for white text

            // Amount Display
            VStack(alignment: .leading, spacing: 8) {
                Text(dashboardViewModel.currentAmount)
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(.white)

                ChangeIndicatorView(
                    isPositive: dashboardViewModel.changeIsPositive,
                    description: dashboardViewModel.changeDescription
                )
            }
            .padding(.horizontal)

            // Chart
            FinancialChartView(data: dashboardViewModel.chartData)
        }
        .padding(.top, 48)
        .padding(.bottom, 24)
        .greenGradientBackground()
        .sheet(isPresented: $showingCreditScore) {
            CreditScoreView()
        }
    }
}

// Separate Accounts Section
struct DashboardMainView: View {
    let accounts: [Account]
    @ObservedObject var dashboardViewModel: DashboardViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            DashboardAccountsList(accounts: accounts, dashboardViewModel: dashboardViewModel)
        }
        .background(Color(uiColor: .systemBackground))
    }
}

// Separate Accounts List
struct DashboardAccountsList: View {
    let accounts: [Account]
    @ObservedObject var dashboardViewModel: DashboardViewModel

    var body: some View {
        VStack(spacing: 16) {
            ForEach(accounts) { account in
                DashboardAccountItemRow(
                    type: account.type,
                    amount: dashboardViewModel.formatAmount(account.amount)
                )
            }
        }
        .padding(.horizontal)
    }
}

// FinancialItemView for each financial category
struct DashboardAccountItemRow: View {
    var type: Account.AccountType
    var amount: String
    
    var body: some View {
        NavigationLink(destination: TransactionsView(accountType: type)) {
            HStack {
                Text(type.rawValue)
                    .font(.system(size: 16))
                    .foregroundColor(.primary)
                Spacer()
                Text(amount)
                    .font(.system(size: 17, weight: .medium))
                    .foregroundColor(amount.contains("-") ? .alertRed : .primaryGreen)
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
