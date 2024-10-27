import SwiftUI
import Charts
import Inject

struct OverviewView: View {
    @ObserveInjection var inject
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    HeaderView(chartData: NetWorthChartView.sampleData)
                    AccountsSection()
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
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Your Accounts")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                .padding(.top, 24)
            
            AccountsList()
        }
    }
}

// Separate Accounts List
struct AccountsList: View {
    var body: some View {
        VStack(spacing: 12) {
            FinancialItemView(title: "Cash", amount: "$5,732")
            FinancialItemView(title: "Credit Cards", amount: "-$4,388")
            FinancialItemView(title: "Investments", amount: "$82,386")
            FinancialItemView(title: "Property", amount: "$302,225")
        }
        .padding(.horizontal)
        .padding(.top, 12)
    }
}

// FinancialItemView for each financial category
struct FinancialItemView: View {
    var title: String
    var amount: String
    
    var body: some View {
        NavigationLink(destination: TransactionsView(accountType: title)) {
            HStack {
                Text(title)
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
