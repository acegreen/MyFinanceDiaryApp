import Inject
import SwiftUI

struct MainView: View {
    @ObserveInjection var inject
    @EnvironmentObject private var appState: AppState

    var body: some View {
        Group {
            if appState.authenticationService.isAuthenticated {
                MainTabView()
                    .transition(.opacity)
            } else {
                LoginView()
                    .transition(.opacity)
            }
        }
        .task {
            if appState.plaidService.hasValidPlaidConnection {
                await fetchProvider()
            } else {
                appState.plaidService.setupPlaidLink()
            }
        }
        .animation(.smooth, value: appState.authenticationService.isAuthenticated)
        .enableInjection()
    }

    private func fetchProvider() async {
        do {
            try await appState.mainViewModel.fetchProvider()
        } catch {
            print("Error fetching provider: \(error)")
        }
    }
}

struct MainTabView: View {
    var body: some View {
        TabView {
            DashboardView()
                .tabItem {
                    Label("Dashboard", systemImage: "bitcoinsign.square.fill")
                }

            BudgetView()
                .tabItem {
                    Label("Budget", systemImage: "switch.2")
                }

            GoalsView()
                .tabItem {
                    Label("Goals", systemImage: "trophy.fill")
                }

            BillsAndPaymentsView()
                .tabItem {
                    Label("Bills", systemImage: "creditcard.fill")
                }

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
        }
        .tint(.darkGreen)
    }
}

#Preview {
    MainView()
        .withPreviewEnvironment()
}
