import SwiftUI
import Inject

struct LoginView: View {
    @ObserveInjection var inject
    @EnvironmentObject private var appState: AppState
    @State private var isLoading = false
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(hex: "1D7B6E"), Color(hex: "1A9882")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("MyFinanceDiary")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.bottom, 30)
                
                VStack(spacing: 16) {
                    TextField("Username", text: $appState.loginViewModel.username)
                        .textFieldStyle(.plain)
                        .padding()
                        .background(Color(.secondarySystemGroupedBackground))
                        .cornerRadius(12)
                        .autocapitalization(.none)
                        .textContentType(.username)
                    
                    SecureField("Password", text: $appState.loginViewModel.password)
                        .textFieldStyle(.plain)
                        .padding()
                        .background(Color(.secondarySystemGroupedBackground))
                        .cornerRadius(12)
                        .textContentType(.password)
                    
                    if appState.loginViewModel.isShowingError {
                        Text(appState.loginViewModel.errorMessage)
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                    
                    Button {
                        Task {
                            guard appState.loginViewModel.validateInput() else { return }
                            
                            isLoading = true
                            do {
                                try await appState.authenticationService.login(
                                    username: appState.loginViewModel.username,
                                    password: appState.loginViewModel.password
                                )
                                await MainActor.run {
                                    appState.loginViewModel.clearFields()
                                    withAnimation {
                                        appState.objectWillChange.send()
                                    }
                                }
                            } catch {
                                appState.loginViewModel.handleError(error)
                            }
                            isLoading = false
                        }
                    } label: {
                        HStack {
                            if isLoading {
                                ProgressView()
                                    .tint(.white)
                            } else {
                                Text("Login")
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .background(Color(hex: "1D7B6E"))
                        .cornerRadius(12)
                    }
                    .buttonStyle(.plain)
                    .disabled(isLoading)
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
