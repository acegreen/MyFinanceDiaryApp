import SwiftUI
import SwiftData
import Inject

struct RecurringPurchaseDetailView: View {
    @ObserveInjection var inject
    @Bindable var purchase: RecurringPurchase
    @State private var showingEditSheet = false

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
                Button("Restock Now") {
                    // Implement restock logic
                }
                .frame(maxWidth: .infinity)
            }
        }
        .navigationTitle(purchase.name)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Edit") {
                    showingEditSheet = true
                }
            }
        }
        .sheet(isPresented: $showingEditSheet) {
            RecurringPurchaseFormView(recurringPurchase: purchase, isNewPurchase: false)
        }
        .enableInjection()
    }
}

#Preview {
    do {
        let preview = try previewContainer.mainContext.fetch(FetchDescriptor<RecurringPurchase>()).first!
        return NavigationView {
            RecurringPurchaseDetailView(purchase: preview)
        }
        .modelContainer(previewContainer)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
