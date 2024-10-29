//
//  MyFinanceDiaryApp.swift
//  MyFinanceDiaryApp
//
//  Created by Ace Green on 2024-10-25.
//

import SwiftUI
import SwiftData
import Inject

@main
struct MyFinanceDiaryApp: App {
    @ObserveInjection var inject    
    @StateObject private var appState = AppState()

    init() {
        #if DEBUG
        injectInit()
        #endif
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.modelContext, appState.container.mainContext)
                .environmentObject(appState)
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
