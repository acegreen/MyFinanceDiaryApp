import SwiftUI
import Charts
import Inject

struct DashboardView: View {
    @ObserveInjection var inject
    @StateObject var viewModel = DashboardViewModel()
    
    var body: some View {
        ViewBuilderWrapper {
            DashboardHeaderView(viewModel: viewModel)
        } main: {
            AccountsSection(accounts: viewModel.accounts)
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
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            AccountsList(accounts: accounts)
        }
        .background(Color(uiColor: .systemBackground))
    }
}

// Separate Accounts List
struct AccountsList: View {
    let accounts: [Account]
    @EnvironmentObject private var viewModel: DashboardViewModel
    
    var body: some View {
        VStack(spacing: 16) { // Increase spacing between items
            ForEach(accounts) { account in
                AccountItemRow(
                    type: account.type,
                    amount: viewModel.formatAmount(account.amount)
                )
            }
        }
        .padding(.horizontal)
    }
}

struct DashboardHeaderView: View {
    @ObservedObject var viewModel: DashboardViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Credit Score Section
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Credit score")
                        .font(.headline)
                        .foregroundColor(.white.opacity(0.9))
                    Text("791")
                        .font(.title2.bold())
                        .foregroundColor(.white)
                }
                Spacer()
            }

            // Tab Selection
            Picker("View Selection", selection: $viewModel.selectedSegment) {
                ForEach(DashboardViewModel.ChartSegment.allCases, id: \.self) { tab in
                    Text(tab.rawValue)
                        .tag(tab)
                }
            }
            .pickerStyle(.segmented)
            .colorScheme(.dark) // Force dark mode for white text

            // Amount Display
            VStack(alignment: .leading, spacing: 8) {
                Text(viewModel.currentAmount)
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(.white)

                HStack(spacing: 4) {
                    Image(systemName: viewModel.changeIsPositive ? "arrow.up" : "arrow.down")
                        .foregroundColor(viewModel.changeIsPositive ? .green : .red)
                    Text(viewModel.changeDescription)
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.9))
                }
            }
            .padding(.top, 8)

            // Chart
            FinancialChartView(data: viewModel.chartData)
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
