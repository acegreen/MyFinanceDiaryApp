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
        .animation(.smooth, value: appState.authenticationService.isAuthenticated)
        .enableInjection()
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
                
            MeView()
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
