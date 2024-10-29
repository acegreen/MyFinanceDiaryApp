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
                    // Amount Header
                    Text(transaction.amount, format: .currency(code: "USD"))
                        .font(.system(size: 48, weight: .regular))
                        .padding(.top, 20)
                    
                    // Merchant and Date
                    VStack(spacing: 4) {
                        Text(transaction.merchantName ?? transaction.name)
                            .font(.title3)
                            .foregroundColor(.secondary)
                        Text(transaction.date.formatted(date: .long, time: .shortened))
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    // Status Card
                    VStack(spacing: 16) {
                        statusRow
                        if let accountName = transaction.accountName {
                            divider
                            HStack {
                                Text("Account")
                                Spacer()
                                Text(accountName)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .padding()
                    .background(Color(uiColor: .secondarySystemGroupedBackground))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    
                    locationCard(for: transaction)
                    
                    // Additional Details Card
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
                    .cornerRadius(10)
                    .padding(.horizontal)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(uiColor: .systemGroupedBackground))
        .enableInjection()
        .task {
            loadedTransaction = appState.transactionDetailsViewModel.getTransaction(id: transactionId)
        }
    }
    
    private func locationCard(for transaction: Transaction) -> some View {
        #if DEBUG
        let coordinates = (latitude: 45.5017, longitude: -73.5673)
        return LocationMapCard(
            title: transaction.merchantName ?? transaction.name,
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
    
    private var statusRow: some View {
        HStack {
            Text("Status")
            Spacer()
            if let transaction = loadedTransaction {
                Text(transaction.pending ? "Pending" : "Completed")
                    .foregroundColor(transaction.pending ? .orange : .green)
            }
        }
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
