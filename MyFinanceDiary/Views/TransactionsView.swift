import SwiftUI
import Inject

struct TransactionsView: View {
    @ObserveInjection var inject
    @EnvironmentObject var appState: AppState
    let accountTypes: [AccountType]
    @State private var refreshID = UUID()
    
    var body: some View {
        Group {
            if appState.transactionsViewModel.groupedTransactions.isEmpty {
                ContentUnavailableView(
                    "No Transactions!",
                    systemImage: "creditcard.trianglebadge.exclamationmark",
                    description: Text("Connect your bank account(s) to see your transactions")
                )
            } else {
                TransactionsList(
                    groupedTransactions: appState.transactionsViewModel.groupedTransactions
                )
            }
        }
        .id(refreshID)
        .scrollContentBackground(.hidden)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                BackButton()
            }
            ToolbarItem(placement: .principal) {
                EmptyView()
            }
        }
        .toolbarRole(.editor)
        .overlay {
            if appState.transactionsViewModel.isLoading {
                ProgressView()
                    .scaleEffect(1.5)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(.ultraThinMaterial)
            }
        }
        .refreshable {
            loadTransactions()
        }
        .task {
            loadTransactions()
        }
        .enableInjection()
    }

    private func loadTransactions() {
        do {
            try appState.transactionsViewModel.loadTransactions(for: accountTypes)
            refreshID = UUID()
        } catch {
            print("Error loading transactions: \(error)")
        }
    }
}

struct TransactionsList: View {
    let groupedTransactions: [Date: [Transaction]]

    var body: some View {
        List {
            ForEach(groupedTransactions.keys.sorted(by: >), id: \.self) { date in
                if let transactions = groupedTransactions[date] {
                    Section(header: Text(date.formatted(.dateTime.month().day().year()))) {
                        ForEach(transactions) { transaction in
                            TransactionRow(transaction: transaction)
                        }
                    }
                }
            }
        }
        .listStyle(.plain)
    }
}

struct TransactionRow: View {
    let transaction: Transaction
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        NavigationLink {
            TransactionDetailsView(transactionId: transaction.transactionId)
        } label: {
            HStack(spacing: 12) {
                if let iconUrl = transaction.displayIconUrl {
                    AsyncImage(url: URL(string: iconUrl)) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                        case .success(let image):
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
    TransactionsView(accountTypes: AccountType.allCases)
        .withPreviewEnvironment()
}
