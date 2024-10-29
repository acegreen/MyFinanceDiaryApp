import SwiftUI

class AuthenticationService: ObservableObject {
    @Published var isAuthenticated = false
    
    @MainActor
    func login(username: String, password: String) async throws {
        // TODO: Add real authentication logic here
        // Simulating network delay
        try await Task.sleep(for: .seconds(1))
        
        // Ensure state update happens on main thread with animation
        withAnimation {
            isAuthenticated = true
            objectWillChange.send()
        }
    }
    
    func logout() {
        isAuthenticated = false
    }
}
