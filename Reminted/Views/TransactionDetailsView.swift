import Inject
import MapKit
import SwiftUI

struct TransactionDetailsView: View {
    @ObserveInjection var inject
    @EnvironmentObject private var appState: AppState
    @StateObject var transactionDetailsViewModel: TransactionDetailsViewModel

    var body: some View {
        Group {
            if let transaction = appState.transactionDetailsViewModel.transaction {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {
                        headerView(transaction)
                        statusView(transaction)
                        locationCardView(transaction)
                        additionalDetailsView(transaction)
                    }
                    .padding()
                }
                .scrollContentBackground(.hidden)
                .background(Color(uiColor: .systemGroupedBackground))
            } else {
                ContentUnavailableView(
                    "No Transaction",
                    systemImage: "creditcard.trianglebadge.exclamationmark",
                    description: Text("Transaction was not found")
                )
            }
        }
        .navigationTitle("Transaction Details")
        .navigationBarStyle()
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                BackButton()
            }
            ToolbarItem(placement: .principal) {
                EmptyView()
            }
        }
        .enableInjection()
    }

    private func headerView(_ transaction: Transaction) -> some View {
        VStack(spacing: 4) {
            // Amount Header
            Text(NumberFormatter.formatAmount(transaction.amount))
                .font(.system(size: 64, weight: .medium))

            // Merchant and Date
            VStack(spacing: 4) {
                Text(transaction.displayName)
                    .font(.title3)
                    .foregroundColor(.secondary)
                Text(transaction.date.formatted(date: .long, time: .shortened))
                    .font(.headline)
                    .foregroundColor(.secondary)
            }
        }
    }

    private func statusView(_ transaction: Transaction) -> some View {
        CardView {
            VStack(spacing: 16) {
                HStack {
                    Text("Status")
                        .font(.headline)
                    Spacer()
                    Text(transaction.pending ? "Pending" : "Completed")
                        .foregroundColor(transaction.pending ? .vibrantOrange : .primaryGreen)
                }
                if let paymentProcessor = transaction.paymentMeta?.paymentProcessor {
                    Text(paymentProcessor)
                        .font(.headline)
                        .foregroundColor(.secondary)
                }
            }
            .padding()
        }
    }

    private func locationCardView(_ transaction: Transaction) -> some View {
        #if DEBUG
            let coordinates = (latitude: 45.5017, longitude: -73.5673)
            return LocationMapCard(
                title: transaction.displayName,
                iconUrl: transaction.displayIconUrl,
                coordinates: coordinates
            )
        #else
            if let location = transaction.location,
               let lat = location.lat,
               let lon = location.lon
            {
                return LocationMapCard(
                    title: transaction.displayName,
                    coordinates: (latitude: lat, longitude: lon)
                )
            } else {
                return EmptyView()
            }
        #endif
    }

    private func additionalDetailsView(_ transaction: Transaction) -> some View {
        CardView {
            VStack(spacing: 16) {
                detailRow(title: "Category", value: transaction.category.map { $0.rawValue }.joined(separator: "\n"))
                divider

                detailRow(title: "Payment Method", value: transaction.paymentChannel.rawValue.capitalized)
                divider

                detailRow(title: "Transaction ID", value: transaction.transactionId)
            }
            .padding()
        }
    }

    private func detailRow(title: String, value: String) -> some View {
        HStack(spacing: 8) {
            Text(title)
            Spacer()
            Text(value)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.trailing)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }

    private var divider: some View {
        Rectangle()
            .fill(Color(uiColor: .separator))
            .frame(height: 0.5)
    }
}

#Preview {
    TransactionDetailsView(
        transactionDetailsViewModel: PreviewHelper.previewTransactionDetailsViewModel
    )
    .withPreviewEnvironment()
}
