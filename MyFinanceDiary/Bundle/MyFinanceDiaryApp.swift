//
//  MyFinanceDiaryApp.swift
//  MyFinanceDiaryApp
//
//  Created by Ace Green on 2024-10-25.
//

import Inject
import SwiftUI

@main
struct MyFinanceDiaryApp: App {
    @ObserveInjection var inject
    @StateObject private var appState = AppState.shared

    init() {
        injectInit()
    }

    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(appState)
                .enableInjection()
        }
    }
}

#if DEBUG
    func injectInit() {
        #if os(macOS)
            let bundleName = "macOSInjection.bundle"
        #elseif os(tvOS)
            let bundleName = "tvOSInjection.bundle"
        #else
            let bundleName = "iOSInjection.bundle"
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
