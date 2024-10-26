//
//  ReStockApp.swift
//  ReStock
//
//  Created by Ace Green on 2024-10-25.
//

import SwiftUI
import SwiftData
import Inject

class AppState: ObservableObject {
    let container: ModelContainer
    
    init() {
        do {
            let schema = Schema([RecurringPurchase.self])
            let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
            container = try ModelContainer(for: schema, configurations: [modelConfiguration])
            
            // Add sample data if needed
            Task {
                await addSampleDataIfNeeded(to: container.mainContext)
            }
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }
}

@main
struct ReStockApp: App {
    @StateObject private var appState = AppState()
    @ObserveInjection var inject
    
    init() {
        #if DEBUG
        injectInit()
        #endif
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .modelContainer(appState.container)
                .task {
                    // Use @MainActor to ensure this runs on the main thread
                    await MainActor.run {
                        let context = appState.container.mainContext
                        // Perform any setup or initial data loading here
                        // For example:
                        // await addSampleDataIfNeeded(to: context)
                    }
                }
                .enableInjection()
        }
    }
}

#if DEBUG
func injectInit() {
    #if targetEnvironment(simulator)
    // For all simulators (including iPad)
    let bundleName = "iOSInjection.bundle"
    #elseif os(iOS)
    let bundleName = "maciOSInjection.bundle"
    #elseif os(macOS)
    let bundleName = "macOSInjection.bundle"
    #else
    let bundleName = "maciOSInjection.bundle"
    #endif
    
    let bundlePath = "/Applications/InjectionIII.app/Contents/Resources/\(bundleName)"
    
    guard let bundle = Bundle(path: bundlePath) else {
        print("❌ Failed to find InjectionIII bundle at path: \(bundlePath)")
        return
    }
    
    do {
        try bundle.load()
        print("✅ Loaded InjectionIII bundle successfully")
    } catch {
        print("❌ Failed to load InjectionIII bundle: \(error)")
    }
}
#endif
