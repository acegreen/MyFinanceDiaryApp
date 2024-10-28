import SwiftUI
import Inject

struct ContentView: View {
    @ObserveInjection var inject
    @EnvironmentObject var authManager: AuthenticationService
    
    var body: some View {
        Group {
            if authManager.isAuthenticated {
                TabView {
                    DashboardView()
                        .tabItem {
                            Label("Dashboard", systemImage: "chart.pie.fill")
                        }
                    
                    BudgetView()
                        .tabItem {
                            Label("Budget", systemImage: "switch.2")
                        }
                }
            } else {
                LoginView()
            }
        }
        .enableInjection()
    }
}
