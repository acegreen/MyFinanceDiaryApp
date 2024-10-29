import SwiftUI
import Inject

struct TransactionsView: View {
    @ObserveInjection var inject
    @EnvironmentObject var appState: AppState
    let accountType: Account.AccountType
    
    var body: some View {
        TransactionsList(groupedTransactions: appState.transactionsViewModel.groupedTransactions)
            .scrollContentBackground(.hidden)
            .navigationTitle("\(accountType.displayName) Transactions")
            .onAppear {
                appState.transactionsViewModel.loadTransactions()
            }
            .overlay {
                if appState.transactionsViewModel.isLoading {
                    ProgressView()
                }
            }
            .enableInjection()
    }
}

// New component for the list
struct TransactionsList: View {
    let groupedTransactions: [Date: [Transaction]]
    
    var body: some View {
        List {
            ForEach(groupedTransactions.keys.sorted(by: >), id: \.self) { date in
                Section(header: Text(date.formatted(.dateTime.month().day().year()))) {
                    ForEach(groupedTransactions[date] ?? []) { transaction in
                        TransactionRow(transaction: transaction)
                    }
                }
            }
        }
    }
}

// New component for the transaction row
struct TransactionRow: View {
    let transaction: Transaction

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(transaction.name)
                    .font(.system(size: 17))
                if let merchantName = transaction.merchantName {
                    Text(merchantName)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            Spacer()
            Text(transaction.amount, format: .currency(code: "USD"))
                .foregroundColor(transaction.amount < 0 ? .red : .green)
        }
    }
}

#Preview {
    NavigationStack {
        TransactionsView(accountType: .cash)
    }
    .withPreviewEnvironment()
}
