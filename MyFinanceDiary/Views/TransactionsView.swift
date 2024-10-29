import SwiftUI
import Inject

struct TransactionsView: View {
    @ObserveInjection var inject
    @EnvironmentObject var appState: AppState
    let accountType: Account.AccountType
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some View {
        TransactionsList(
            filteredTransactions: appState.transactionsViewModel.getFilteredTransactions(for: accountType)
        )
            .scrollContentBackground(.hidden)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    BackButton()
                }
            }
            .toolbarRole(.editor)
            .task {
                if !appState.plaidService.hasValidPlaidConnection {
                    await MainActor.run {
                        appState.plaidService.setupPlaidLink()
                    }
                } else {
                    await loadTransactions(for: accountType)
                }
            }
            .onChange(of: scenePhase) { oldPhase, newPhase in
                if newPhase == .active {
                    Task {
                        await loadTransactions(for: accountType)
                    }
                }
            }
            .refreshable {
                await loadTransactions(for: accountType)
            }
            .overlay {
                if appState.transactionsViewModel.isLoading {
                    ProgressView()
                        .scaleEffect(1.5)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(.ultraThinMaterial)
                }
            }
            .enableInjection()
    }
    
    private func loadTransactions(for accountType: Account.AccountType) async {
        do {
            try await appState.transactionsViewModel.loadTransactions(for: accountType)
        } catch PlaidService.PlaidError.noPlaidConnection {
            await MainActor.run {
                appState.plaidService.setupPlaidLink()
            }
        } catch {
            print("Error loading transactions: \(error)")
        }
    }
}

// New component for the list
struct TransactionsList: View {
    let filteredTransactions: [Date: [Transaction]]
    
    var body: some View {
        List {
            ForEach(filteredTransactions.keys.sorted(by: >), id: \.self) { date in
                Section(header: Text(date.formatted(.dateTime.month().day().year()))) {
                    ForEach(filteredTransactions[date] ?? []) { transaction in
                        TransactionRow(transaction: transaction)
                    }
                }
            }
        }
        .listStyle(.plain)
    }
}

// New component for the transaction row
struct TransactionRow: View {
    let transaction: Transaction
    @EnvironmentObject var appState: AppState

    var body: some View {
        NavigationLink {
            TransactionDetailsView(transactionId: transaction.transactionId)
                .onAppear {
                    appState.transactionDetailsViewModel.setTransaction(transaction)
                }
                .onDisappear {
                    appState.transactionDetailsViewModel.clearTransaction()
                }
        } label: {
            HStack(spacing: 12) {
                
                if let iconUrl = transaction.categoryIconUrl {
                    AsyncImage(url: URL(string: iconUrl)) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        case .failure(let error):
                            Image(systemName: "exclamationmark.triangle")
                        @unknown default:
                            EmptyView()
                        }
                    }
                    .frame(width: 40, height: 40)
                } else {
                    Image(systemName: "dollarsign.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.gray)
                        .frame(width: 40, height: 40)
                }
                
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
            .padding(.vertical, 4)
        }
    }
}

#Preview {
    NavigationStack {
        TransactionsView(accountType: .cash)
    }
    .withPreviewEnvironment()
}
