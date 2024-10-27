import SwiftUI
import SwiftData
import Inject

@MainActor
class AppState: ObservableObject {
    @ObserveInjection var inject
    
    let container: ModelContainer
    let orderingService: OrderingService
    
    init() {
        do {
            let schema = Schema([Transaction.self])
            let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
            container = try ModelContainer(for: schema, configurations: [modelConfiguration])
            
            orderingService = OrderingService()
            
            // Add sample data if needed
            Task {
                await addSampleDataIfNeeded(to: container.mainContext)
            }
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }
    
    func addSampleDataIfNeeded(to context: ModelContext) async {
        // Implement your sample data logic here
    }
}

#if DEBUG
extension AppState {
    static var preview: AppState {
        let appState = AppState()
        // Add any preview-specific setup here
        return appState
    }
}
#endif
