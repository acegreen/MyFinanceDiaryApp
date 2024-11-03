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
    @State private var showMenu: Bool = false

    var body: some View {
        NavigationStack(path: $navigationPath) {
            TabView {
                DashboardView(showMenu: $showMenu)
                    .tabItem {
                        Label("Dashboard", systemImage: "bitcoinsign.square.fill")
                    }

                InsightsView(showMenu: $showMenu)
                    .tabItem {
                        Label("Insights", systemImage: "chart.line.uptrend.xyaxis")
                    }

                BudgetView(showMenu: $showMenu)
                    .tabItem {
                        Label("Budget", systemImage: "switch.2")
                    }

                GoalsView(showMenu: $showMenu)
                    .tabItem {
                        Label("Goals", systemImage: "trophy.fill")
                    }

                BillsAndPaymentsView(showMenu: $showMenu)
                    .tabItem {
                        Label("Bills", systemImage: "creditcard.fill")
                    }
            }
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        showMenu.toggle()
                    } label: {
                        Image(systemName: "line.3.horizontal")
                            .foregroundColor(.white)
                    }
                    .popoverSheet(isPresented: $showMenu) { height in
                        MenuView(height: height, navigationPath: $navigationPath)
                    }
                }
            }
            .navigationDestination(for: MenuView.MenuDestination.self) { destination in
                switch destination {
                case .settings:
                    SettingsView()
                case .support:
                    EmptyView()
                case .review:
                    EmptyView()
                case .share:
                    EmptyView()
                }
            }
        }
        .tint(.darkGreen)
    }
}

#Preview {
    MainView()
        .withPreviewEnvironment()
}
