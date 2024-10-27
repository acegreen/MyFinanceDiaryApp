import SwiftUI
import SwiftData
import Inject

struct RecurringPurchaseDetailView: View {
    @ObserveInjection var inject
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var appState: AppState
    @Bindable var purchase: RecurringPurchase
    @State private var isLoading = false
    @State private var orderResult: OrderingService.Order?
    @State private var errorMessage: String?
    @State private var refreshTrigger = false
    
    var body: some View {
        Form {
            Section(header: Text("Details")) {
                Text("Name: \(purchase.name)")
                Text("Category: \(purchase.category.rawValue)")
                Text("Frequency: \(purchase.frequency.rawValue)")
                if let nextPurchaseDate = purchase.nextPurchaseDate {
                    Text("Next Purchase: \(nextPurchaseDate, style: .date)")
                }
            }

            Section {
                Button(action: MyFinanceDiaryAppNow) {
                    if isLoading {
                        ProgressView()
                    } else {
                        Text("MyFinanceDiaryApp Now")
                    }
                }
                .disabled(isLoading)
            }
            
            if let order = orderResult {
                Section {
                    Text("Order placed successfully")
                    Text("Order ID: \(order.id)")
                    // Add more order details as needed
                }
            }
            
            if let error = errorMessage {
                Section {
                    Text(error)
                        .foregroundColor(.red)
                }
            }
        }
        .navigationTitle("Purchase Details")
        .enableInjection()
    }
    
    private func MyFinanceDiaryAppNow() {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let orderItem = OrderingService.OrderItem(
                    id: UUID(),
                    name: purchase.name,
                    quantity: purchase.quantity,
                    price: purchase.price
                )

                let order = try await appState.orderingService.placeOrder(
                    items: [orderItem],
                    provider: purchase.provider
                )
                
                await MainActor.run {
                    orderResult = order
                    PurchaseScheduler.updateNextPurchaseDate(for: purchase)
                    do {
                        try modelContext.save()
                        refreshTrigger.toggle()
                    } catch {
                        errorMessage = "Error saving changes: \(error.localizedDescription)"
                    }
                    isLoading = false
                }
            } catch {
                await MainActor.run {
                    errorMessage = "Error placing order: \(error.localizedDescription)"
                    isLoading = false
                }
            }
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: RecurringPurchase.self, configurations: config)
        let example = RecurringPurchase(name: "Example", category: .groceries)
        return NavigationView {
            RecurringPurchaseDetailView(purchase: example)
                .withPreviewEnvironment()
        }
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
