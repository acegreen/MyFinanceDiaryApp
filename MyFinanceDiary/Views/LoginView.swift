import SwiftUI
import Inject

struct LoginView: View {
    @ObserveInjection var inject
    @EnvironmentObject var authManager: AuthenticationService
    @State private var username = ""
    @State private var password = ""
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(hex: "1D7B6E"), Color(hex: "1A9882")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("My Finance Diary")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.bottom, 30)
                
                VStack(spacing: 16) {
                    TextField("Username", text: $username)
                        .textFieldStyle(.plain)
                        .padding()
                        .background(Color(.secondarySystemGroupedBackground))
                        .cornerRadius(12)
                    
                    SecureField("Password", text: $password)
                        .textFieldStyle(.plain)
                        .padding()
                        .background(Color(.secondarySystemGroupedBackground))
                        .cornerRadius(12)
                    
                    Button(action: {
                        authManager.login(username: username, password: password)
                    }) {
                        Text("Login")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 48)
                            .background(Color.blue)
                            .cornerRadius(12)
                    }
                }
                .padding(.horizontal)
            }
            .padding()
        }
        .enableInjection()
    }
}

#Preview {
    LoginView()
        .withPreviewEnvironment()
}
