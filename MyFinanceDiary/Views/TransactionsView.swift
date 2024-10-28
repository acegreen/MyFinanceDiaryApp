import SwiftUI
import Inject

struct TransactionsView: View {
    @ObserveInjection var inject
    @StateObject private var viewModel = TransactionsViewModel()
    let accountType: Account.AccountType
    
    var body: some View {
        TransactionsList(groupedTransactions: viewModel.groupedTransactions)
            .scrollContentBackground(.hidden)
            .navigationTitle("\(accountType.displayName) Transactions")
            .task {
                await viewModel.loadTransactions()
            }
            .overlay {
                if viewModel.isLoading {
                    ProgressView()
                }
            }
            .alert("Error", isPresented: .constant(viewModel.error != nil), actions: {
                Button("OK") {
                    viewModel.dismissError()
                }
            }, message: {
                Text(viewModel.error?.localizedDescription ?? "Unknown error")
            })
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
                Text(transaction.transactionDescription)
                    .font(.system(size: 17))
            }
            Spacer()
            Text(transaction.amount, format: .currency(code: "USD"))
                .foregroundColor(transaction.type == .debit ? .red : .green)
        }
    }
}

#Preview {
    NavigationStack {
        TransactionsView(accountType: .cash)
    }
    .withPreviewEnvironment()
}
