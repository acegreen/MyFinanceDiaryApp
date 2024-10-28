import SwiftUI
import Charts
import Inject

struct OverviewView: View {
    @ObserveInjection var inject
    @StateObject private var viewModel = OverviewViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    HeaderView(chartData: viewModel.netWorthData)
                    AccountsSection(accounts: viewModel.accounts)
                }
            }
            .background(Color(.systemGray6))
            .navigationBarTitleDisplayMode(.inline)
            .ignoresSafeArea()
        }
        .enableInjection()
    }
}

// Separate Accounts Section
struct AccountsSection: View {
    let accounts: [Account]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Your Accounts")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                .padding(.top, 24)
            
            AccountsList(accounts: accounts)
        }
    }
}

// Separate Accounts List
struct AccountsList: View {
    let accounts: [Account]
    @EnvironmentObject private var viewModel: OverviewViewModel
    
    var body: some View {
        VStack(spacing: 12) {
            ForEach(accounts) { account in
                FinancialItemView(
                    type: account.type,
                    amount: viewModel.formatAmount(account.amount)
                )
            }
        }
        .padding(.horizontal)
        .padding(.top, 12)
    }
}

// FinancialItemView for each financial category
struct FinancialItemView: View {
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
            .padding(.vertical, 12)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 2)
        }
    }
}

#Preview {
    OverviewView()
        .withPreviewEnvironment()
}
