import Inject
import SwiftUI

struct TransactionsView: View {
    @ObserveInjection var inject
    @EnvironmentObject var appState: AppState
    @StateObject var transactionsViewModel: TransactionsViewModel
    @StateObject var transactionDetailsViewModel: TransactionDetailsViewModel
    let accountTypes: [AccountType]

    var body: some View {
        Group {
            if transactionsViewModel.groupedTransactions != nil {
                TransactionsList(
                    transactionsViewModel: transactionsViewModel,
                    transactionDetailsViewModel: transactionDetailsViewModel
                )
            } else {
                ContentUnavailableView(
                    "No Transactions",
                    systemImage: "creditcard.trianglebadge.exclamationmark",
                    description: Text("Connect your bank account(s) to see your transactions")
                )
            }
        }
        .navigationTitle("Transactions")
        .navigationBarStyle()
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                BackButton()
            }
            ToolbarItem(placement: .principal) {
                EmptyView()
            }
        }
        .overlay {
            if transactionsViewModel.isLoading {
                ProgressView()
                    .scaleEffect(1.5)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(.ultraThinMaterial)
            }
        }
        .onAppear {
            loadTransactions()
        }
        .refreshable {
            loadTransactions()
        }
        .enableInjection()
    }

    private func loadTransactions() {
        do {
            try transactionsViewModel.loadTransactions(for: accountTypes)
        } catch {
            print("Error loading transactions: \(error)")
        }
    }
}

struct TransactionsList: View {
    @StateObject var transactionsViewModel: TransactionsViewModel
    @StateObject var transactionDetailsViewModel: TransactionDetailsViewModel

    var body: some View {
        if let groupedTransactions = transactionsViewModel.groupedTransactions {
            List {
                ForEach(groupedTransactions.sorted(by: { $0.key > $1.key }), id: \.key) { date, transactions in
                    Section(header: Text(date.formatted(.dateTime.month().day().year()))) {
                        ForEach(transactions) { transaction in
                            TransactionRow(transaction: transaction)
                        }
                    }
                }
            }
            .listStyle(.plain)
        }
    }
}

struct TransactionRow: View {
    @EnvironmentObject var appState: AppState
    var transaction: Transaction

    var body: some View {
        NavigationLink(destination: {
            TransactionDetailsView(transactionDetailsViewModel: appState.transactionDetailsViewModel)
                .onAppear {
                    appState.transactionDetailsViewModel.setTransaction(transaction)
                }
        }) {
            HStack(spacing: 12) {
                if let iconUrl = transaction.displayIconUrl {
                    AsyncImage(url: URL(string: iconUrl)) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                        case let .success(image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        case .failure:
                            Image(systemName: "exclamationmark.triangle")
                        @unknown default:
                            EmptyView()
                        }
                    }
                    .frame(width: 40, height: 40)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(20)
                } else {
                    Image(systemName: "dollarsign.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.gray)
                        .frame(width: 40, height: 40)
                }

                VStack(alignment: .leading) {
                    Text(transaction.name)
                        .font(.system(size: 18))
                    if let merchantName = transaction.merchantName {
                        Text(merchantName)
                            .font(.subheadline.bold())
                            .foregroundColor(.secondary)
                    }
                }

                Spacer()

                Text(NumberFormatter.formatAmount(transaction.amount))
                    .foregroundColor(transaction.amount < 0 ? .alertRed : .primaryGreen)
            }
            .padding(.vertical, 4)
        }
    }
}

#Preview {
    TransactionsView(transactionsViewModel: PreviewHelper.previewTransactionsViewModel,
                     transactionDetailsViewModel: PreviewHelper.previewTransactionDetailsViewModel,
                     accountTypes: AccountType.allCases)
        .withPreviewEnvironment()
}
