import SwiftUI
import Inject

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
        .animation(.default, value: appState.authenticationService.isAuthenticated)
        .enableInjection()
    }
}

struct MainTabView: View {
    var body: some View {
        TabView {
            DashboardView()
                .tabItem {
                    Label("Dashboard", systemImage: "chart.pie.fill")
                }
            
            BudgetView()
                .tabItem {
                    Label("Budget", systemImage: "switch.2")
                }
            
            GoalsView()
                .tabItem {
                    Label("Goals", systemImage: "trophy.fill")
                }
        }
        .tint(.darkGreen)
    }
}
