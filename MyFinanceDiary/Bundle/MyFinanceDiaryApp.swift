//
//  MyFinanceDiaryApp.swift
//  MyFinanceDiaryApp
//
//  Created by Ace Green on 2024-10-25.
//

import SwiftUI
import Inject

@main
struct MyFinanceDiaryApp: App {
    @StateObject private var appState = AppState()
    @ObserveInjection var inject
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(appState)
        }
    }
}
