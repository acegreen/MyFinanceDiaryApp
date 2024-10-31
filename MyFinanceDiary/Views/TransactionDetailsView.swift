import SwiftUI
import MapKit
import Inject

struct TransactionDetailsView: View {
    @ObserveInjection var inject
    @EnvironmentObject private var appState: AppState
    @State private var loadedTransaction: Transaction?
    let transactionId: String
    
    var body: some View {
        ScrollView {
            if let transaction = loadedTransaction {
                VStack(spacing: 16) {
                    headerView(transaction)
                    
                    statusView(transaction)

                    locationCard(for: transaction)
                    
                    additionalDetailsView(transaction)
                }
            }
        }
        .padding()
        .background(Color(uiColor: .systemGroupedBackground))
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
        .toolbarBackground(.hidden, for: .navigationBar)
        .enableInjection()
        .task {
            loadedTransaction = appState.transactionDetailsViewModel.getTransaction(id: transactionId)
        }
    }
    
    private func headerView(_ transaction: Transaction) -> some View {
        VStack(spacing: 4) {
            // Amount Header
            Text(transaction.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                .font(.system(size: 64, weight: .medium))

            // Merchant and Date
            VStack(spacing: 4) {
                Text(transaction.merchantName ?? transaction.name)
                    .font(.title2)
                    .foregroundColor(.secondary)
                Text(transaction.date.formatted(date: .long, time: .shortened))
                    .font(.headline)
                    .foregroundColor(.secondary)
            }
        }
    }

    private func statusView(_ transaction: Transaction) -> some View {
        VStack(spacing: 16) {
            HStack {
                Text("Status")
                    .font(.headline)
                Spacer()
                if let transaction = loadedTransaction {
                    Text(transaction.pending ? "Pending" : "Completed")
                        .foregroundColor(transaction.pending ? .vibrantOrange : .primaryGreen)
                }
            }
            if let paymentChannel = transaction.paymentChannel {
                Text(paymentChannel)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .cornerRadius(12)
    }

    private func additionalDetailsView(_ transaction: Transaction) -> some View {
        VStack(spacing: 16) {
            if let category = transaction.category {
                detailRow(title: "Category", value: category.rawValue)
                divider
            }

            if let paymentChannel = transaction.paymentChannel {
                detailRow(title: "Payment Method", value: paymentChannel.capitalized)
                divider
            }

            detailRow(title: "Transaction ID", value: transaction.transactionId)
        }
        .padding()
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .cornerRadius(12)
    }

    private func locationCard(for transaction: Transaction) -> some View {
        #if DEBUG
        let coordinates = (latitude: 45.5017, longitude: -73.5673)
        return LocationMapCard(
            title: transaction.merchantName ?? transaction.name,
            iconUrl: transaction.displayIconUrl,
            coordinates: coordinates
        )
        #else
        if let location = transaction.location,
           let lat = location.lat,
           let lon = location.lon {
            return LocationMapCard(
                title: transaction.merchantName ?? transaction.name,
                coordinates: (latitude: lat, longitude: lon)
            )
        } else {
            return EmptyView()
        }
        #endif
    }
    
    private func detailRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
            Spacer()
            Text(value)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.trailing)
        }
    }
    
    private var divider: some View {
        Rectangle()
            .fill(Color(uiColor: .separator))
            .frame(height: 0.5)
    }
}

#Preview {
    NavigationStack {
        TransactionDetailsView(transactionId: "preview-id")
    }
    .withPreviewEnvironment()
} 
