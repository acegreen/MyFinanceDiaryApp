import Charts
import Inject
import SwiftUI

struct DashboardView: View {
    @ObserveInjection var inject
    @EnvironmentObject var appState: AppState
    @State private var navigationPath = NavigationPath()
    @State var showMenu: Bool = false
    @State var showNotifications: Bool = false

    var body: some View {
        NavigationStack(path: $navigationPath) {
            ViewBuilderWrapper {
                DashboardHeaderView(dashboardViewModel: appState.dashboardViewModel)
            } main: {
                DashboardMainView(accounts: appState.dashboardViewModel.accounts,
                                  transactionViewModel: appState.transactionsViewModel,
                                  transactionDetailsViewModel: appState.transactionDetailsViewModel)
            }
            .navigationBarStyle()
            .toolbar {
                Button {
                    navigationPath.append(NotificationsView.NotificationDestination.notifications)
                } label: {
                    Image(systemName: "bell")
                        .foregroundColor(.white)
                }
                Button {
                    showMenu.toggle()
                } label: {
                    Image(systemName: "line.3.horizontal")
                        .foregroundColor(.white)
                }
                .popoverSheet(isPresented: $showMenu) { height in
                    MenuView(height: height, navigationPath: $navigationPath)
                }
            }
            .navigationDestination(for: MenuView.MenuDestination.self) { destination in
                switch destination {
                case .settings:
                    SettingsView()
                case .support:
                    EmptyView()
                case .review:
                    EmptyView()
                case .share:
                    EmptyView()
                }
            }
            .sheet(isPresented: $showNotifications) {
                NotificationsView()
            }
        }
        .enableInjection()
    }
}

struct DashboardHeaderView: View {
    @StateObject var dashboardViewModel: DashboardViewModel
    @State private var showingCreditScore = false

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Credit Score Section
            Button(action: {
                showingCreditScore = true
            }) {
                VStack(alignment: .leading, spacing: 0) {
                    Text("Credit score")
                        .font(.headline)
                        .foregroundColor(.white.opacity(0.9))
                    Text("\(dashboardViewModel.creditScore)")
                        .font(.title2.bold())
                        .foregroundColor(.white)
                }
            }
            .padding(.horizontal)
            .buttonStyle(PlainButtonStyle())

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
                    .font(.system(size: 48, weight: .bold))
                    .foregroundColor(.white)

                ChangeIndicatorView(
                    isPositive: dashboardViewModel.changeIsPositive,
                    description: dashboardViewModel.changeDescription
                )
            }
            .padding(.horizontal)

            // Chart
            FinancialChartView(data: dashboardViewModel.chartData)
                .frame(maxWidth: .infinity, minHeight: 200)
        }
        .padding(.top, 48)
        .greenGradientBackground()
        .sheet(isPresented: $showingCreditScore) {
            CreditScoreView()
        }
    }
}

// Separate Accounts Section
struct DashboardMainView: View {
    let accounts: [DashboardAccount]
    @StateObject var transactionViewModel: TransactionsViewModel
    @StateObject var transactionDetailsViewModel: TransactionDetailsViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            DashboardAccountsList(accounts: accounts,
                                  transactionsViewModel: transactionViewModel,
                                  transactionDetailsViewModel: transactionDetailsViewModel)
        }
    }
}

// Separate Accounts List
struct DashboardAccountsList: View {
    let accounts: [DashboardAccount]
    @StateObject var transactionsViewModel: TransactionsViewModel
    @StateObject var transactionDetailsViewModel: TransactionDetailsViewModel

    var body: some View {
        LazyVStack(spacing: 16) {
            ForEach(accounts) { account in
                DashboardAccountItemRow(account: account,
                                        transactionsViewModel: transactionsViewModel,
                                        transactionDetailsViewModel: transactionDetailsViewModel)
            }
        }
        .padding()
    }
}

// FinancialItemView for each financial category
struct DashboardAccountItemRow: View {
    var account: DashboardAccount
    @StateObject var transactionsViewModel: TransactionsViewModel
    @StateObject var transactionDetailsViewModel: TransactionDetailsViewModel

    var body: some View {
        NavigationLink(destination: TransactionsView(transactionsViewModel: transactionsViewModel,
                                                     transactionDetailsViewModel: transactionDetailsViewModel,
                                                     accountTypes: account.toAccountTypes()))
        {
            CardView {
                HStack {
                    Text(account.id.rawValue)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.primary)
                    Spacer()
                    Text(String(NumberFormatter.formatAmount(account.value)))
                        .font(.system(size: 20, weight: .heavy))
                        .foregroundColor(account.isNegative ? .alertRed : .primaryGreen)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 16)
            }
        }
    }
}

#Preview {
    DashboardView()
        .withPreviewEnvironment()
}
