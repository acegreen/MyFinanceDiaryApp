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
    @State private var navigationPath = NavigationPath()

    var body: some View {
        TabView {
            DashboardView()
                .tabItem {
                    Label("Dashboard", systemImage: "switch.2")
                }

            InsightsView()
                .tabItem {
                    Label("Insights", systemImage: "chart.line.uptrend.xyaxis")
                }

            BudgetView()
                .tabItem {
                    Label("Budget", systemImage: "chart.pie.fill")
                }

            GoalsView()
                .tabItem {
                    Label("Goals", systemImage: "target")
                }

            BillsAndPaymentsView()
                .tabItem {
                    Label("Bills", systemImage: "creditcard.fill")
                }
        }
        .tint(.darkGreen)
    }
}

#Preview {
    MainView()
        .withPreviewEnvironment()
}
