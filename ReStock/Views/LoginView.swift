import SwiftUI
import Inject

struct LoginView: View {
    @ObserveInjection var inject
    @EnvironmentObject var authManager: AuthenticationService
    @State private var username = ""
    @State private var password = ""
    
    var body: some View {
        VStack {
            TextField("Username", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button("Login") {
                authManager.login(username: username, password: password)
            }
            .padding()
        }
        .padding()
        .enableInjection()
    }
}

#Preview {
    LoginView()
        .withPreviewEnvironment()
}
