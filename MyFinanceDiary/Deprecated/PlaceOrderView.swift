import SwiftUI
import Inject

struct PlaceOrderView: View {
    @ObserveInjection var inject
    @EnvironmentObject var appState: AppState
    @State private var items: [OrderingService.OrderItem] = []
    @State private var selectedProvider: OrderingService.Provider = .amazon // Default provider
    @State private var isLoading = false
    @State private var orderResult: OrderingService.Order?
    
    var body: some View {
        Form {
            // Add UI elements for selecting items, provider, etc.
            
            Button("Place Order") {
                placeOrder()
            }
            .disabled(items.isEmpty || isLoading)
            
            if isLoading {
                ProgressView()
            }
            
            if let order = orderResult {
                Text("Order placed successfully: \(order.id)")
            }
        }
        .enableInjection()
    }
    
    private func placeOrder() {
        isLoading = true
        Task {
            do {
                let order = try await appState.orderingService.placeOrder(items: items, provider: selectedProvider)
                await MainActor.run {
                    orderResult = order
                    isLoading = false
                }
            } catch {
                print("Error placing order: \(error)")
                await MainActor.run {
                    isLoading = false
                }
            }
        }
    }
}

#Preview {
    PlaceOrderView()
        .withPreviewEnvironment()
}
