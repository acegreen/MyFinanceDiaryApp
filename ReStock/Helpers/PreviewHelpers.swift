import SwiftUI
import SwiftData

@MainActor
let previewContainer: ModelContainer = {
    do {
        let container = try ModelContainer(for: RecurringPurchase.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        let context = container.mainContext
        Task {
            await addSampleDataIfNeeded(to: context)
        }
        return container
    } catch {
        fatalError("Failed to create model container for previewing: \(error.localizedDescription)")
    }
}()

@MainActor
func addSampleDataIfNeeded(to context: ModelContext) async {
    let fetchDescriptor = FetchDescriptor<RecurringPurchase>(predicate: nil, sortBy: [SortDescriptor(\.name)])
    
    do {
        let existingPurchases = try context.fetch(fetchDescriptor)
        if existingPurchases.isEmpty {
            addSampleData(modelContext: context)
        }
    } catch {
        print("Failed to fetch existing purchases: \(error)")
    }
}

@MainActor
func addSampleData(modelContext: ModelContext) {
    let samplePurchases = [
            RecurringPurchase(
                name: "Coffee Beans",
                category: .groceries,
                frequency: .weekly,
                quantity: 1,
                autoOrder: true,
                notifyBeforeShipping: false,
                notes: "Dark roast",
                nextPurchaseDate: Date().addingTimeInterval(7 * 24 * 60 * 60),
                price: 12.99
            ),
            RecurringPurchase(
                name: "Laundry Detergent",
                category: .household,
                frequency: .monthly,
                quantity: 1,
                autoOrder: false,
                notifyBeforeShipping: true,
                notes: "Sensitive skin formula",
                nextPurchaseDate: Date().addingTimeInterval(30 * 24 * 60 * 60),
                price: 19.99
            ),
            RecurringPurchase(
                name: "Dog Food",
                category: .petSupplies,
                frequency: .biweekly,
                quantity: 2,
                autoOrder: true,
                notifyBeforeShipping: true,
                notes: "Large breed formula",
                nextPurchaseDate: Date().addingTimeInterval(14 * 24 * 60 * 60),
                price: 54.99
            ),
            RecurringPurchase(
                name: "Toothpaste",
                category: .personalCare,
                frequency: .monthly,
                quantity: 3,
                autoOrder: false,
                notifyBeforeShipping: false,
                notes: "Whitening",
                nextPurchaseDate: Date().addingTimeInterval(21 * 24 * 60 * 60),
                price: 4.99
            ),
            RecurringPurchase(
                name: "Paper Towels",
                category: .household,
                frequency: .monthly,
                quantity: 2,
                autoOrder: true,
                notifyBeforeShipping: false,
                notes: "Recycled",
                nextPurchaseDate: Date().addingTimeInterval(25 * 24 * 60 * 60),
                price: 15.99
            ),
            RecurringPurchase(
                name: "Multivitamins",
                category: .personalCare,
                frequency: .monthly,
                quantity: 1,
                autoOrder: true,
                notifyBeforeShipping: true,
                notes: "Adult formula",
                nextPurchaseDate: Date().addingTimeInterval(28 * 24 * 60 * 60),
                price: 24.99
            ),
            RecurringPurchase(
                name: "Cat Litter",
                category: .petSupplies,
                frequency: .biweekly,
                quantity: 1,
                autoOrder: false,
                notifyBeforeShipping: true,
                notes: "Clumping",
                nextPurchaseDate: Date().addingTimeInterval(10 * 24 * 60 * 60),
                price: 17.99
            ),
            RecurringPurchase(
                name: "Protein Powder",
                category: .groceries,
                frequency: .monthly,
                quantity: 1,
                autoOrder: true,
                notifyBeforeShipping: false,
                notes: "Vanilla flavor",
                nextPurchaseDate: Date().addingTimeInterval(27 * 24 * 60 * 60),
                price: 39.99
            ),
            RecurringPurchase(
                name: "Dish Soap",
                category: .household,
                frequency: .monthly,
                quantity: 2,
                autoOrder: false,
                notifyBeforeShipping: false,
                notes: "Lemon scent",
                nextPurchaseDate: Date().addingTimeInterval(23 * 24 * 60 * 60),
                price: 3.99
            ),
            RecurringPurchase(
                name: "Shampoo",
                category: .personalCare,
                frequency: .monthly,
                quantity: 1,
                autoOrder: true,
                notifyBeforeShipping: true,
                notes: "For dry hair",
                nextPurchaseDate: Date().addingTimeInterval(26 * 24 * 60 * 60),
                price: 9.99
            )
        ]
    
    for purchase in samplePurchases {
        modelContext.insert(purchase)
    }
    
    do {
        try modelContext.save()
    } catch {
        print("Failed to save sample data: \(error)")
    }
}

// Add this new property at the top level of the file
@MainActor
let previewAppState: AppState = {
    let appState = AppState()
    // Initialize appState with any necessary mock data or settings
    return appState
}()

// Add this extension at the bottom of the file
extension View {
    func withPreviewEnvironment() -> some View {
        self
            .modelContainer(previewContainer)
            .environmentObject(previewAppState)
    }
}
