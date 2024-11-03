import Inject
import SwiftUI

struct BillsAndPaymentsView: View {
    @ObserveInjection var inject
    @EnvironmentObject var appState: AppState
    @Binding var showMenu: Bool
    @State private var selectedSegment: BillSegment = .bills

    // Sample data for bills
    let bills: [Bill] = [
        Bill(title: "LinkedIn Gold", amount: 9.99, dueDate: "New"),
        Bill(title: "Spotify", amount: 7.50, dueDate: "New"),
        Bill(title: "Netflix", amount: 15.00, dueDate: "+$5.50"),
    ]

    var body: some View {
        ViewBuilderWrapper {
            BillsAndPaymentsHeaderView(selectedSegment: $selectedSegment)
        } main: {
            BillsAndPaymentsMainView(bills: bills)
        }
    }
}

// MARK: - Header Component

private struct BillsAndPaymentsHeaderView: View {
    @Binding var selectedSegment: BillSegment

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            Text("Bills and Subscriptions")
                .font(.title)
                .foregroundColor(.white)
            Picker("View Selection", selection: $selectedSegment) {
                ForEach(BillSegment.allCases, id: \.self) { segment in
                    Text(segment.rawValue)
                        .tag(segment)
                }
            }
            .pickerStyle(.segmented)
            .colorScheme(.dark)

            VStack(alignment: .leading, spacing: 8) {
                Text("You paid $45 for\nsubscriptions in Jan")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)

                Text("You also paid $56 more on subscriptions.")
                    .font(.headline)
                    .foregroundColor(.white)
            }
        }
        .padding(.top, 48)
        .padding()
        .greenGradientBackground()
    }
}

// MARK: - Main Component

private struct BillsAndPaymentsMainView: View {
    let bills: [Bill]

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("New")
                .font(.headline)
                .foregroundColor(.black)

            LazyVStack(spacing: 12) {
                ForEach(bills) { bill in
                    BillRow(bill: bill)
                }
            }
        }
        .padding()
    }
}

struct BillRow: View {
    let bill: Bill

    var body: some View {
        HStack(spacing: 16) {
            // Icon placeholder - replace with actual service icons
            Circle()
                .fill(Color.gray.opacity(0.1))
                .frame(width: 40, height: 40)
                .overlay(
                    Text(bill.title.prefix(1))
                        .foregroundColor(.gray)
                )

            VStack(alignment: .leading, spacing: 4) {
                Text(bill.title)
                    .font(.body)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 4) {
                Text("$\(bill.amount, specifier: "%.2f")")
                    .font(.body)
                    .fontWeight(.medium)

                Text(bill.dueDate)
                    .font(.subheadline)
                    .foregroundColor(bill.dueDate.contains("+") ? .orange : .green)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
    }
}

#Preview {
    BillsAndPaymentsView(showMenu: .constant(false))
        .withPreviewEnvironment()
}
