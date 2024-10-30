import SwiftUI
import Inject

struct LoginView: View {
    @ObserveInjection var inject
    @EnvironmentObject private var appState: AppState
    @State private var isLoading = false
    @FocusState private var focusedField: Field?
    
    private enum Field {
        case username
        case password
    }
    
    var body: some View {
        VStack(spacing: 20) {            
            Text("MyFinanceDiary")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.white)
            
            VStack(spacing: 16) {
                TextField("Username", text: $appState.loginViewModel.username)
                    .textFieldStyle(.plain)
                    .padding()
                    .background(Color(.secondarySystemGroupedBackground))
                    .cornerRadius(12)
                    .autocapitalization(.none)
                    .textContentType(.username)
                    .focused($focusedField, equals: .username)
                    .submitLabel(.next)

                SecureField("Password", text: $appState.loginViewModel.password)
                    .textFieldStyle(.plain)
                    .padding()
                    .background(Color(.secondarySystemGroupedBackground))
                    .cornerRadius(12)
                    .textContentType(.password)
                    .focused($focusedField, equals: .password)
                    .submitLabel(.go)

                if appState.loginViewModel.isShowingError {
                    Text(appState.loginViewModel.errorMessage)
                        .foregroundColor(.alertRed)
                        .font(.subheadline.bold())
                }

                Button {
                    Task { await performLogin() }
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
                    .frame(maxWidth: .infinity, minHeight: 48)
                    .background(Color.darkGreen)
                    .cornerRadius(12)
                }
                .buttonStyle(.plain)
                .disabled(isLoading)
            }
            .padding(.horizontal, 20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .greenGradientBackground()
        .enableInjection()
        .onTapGesture {
            focusedField = nil
        }
    }
    
    private func performLogin() async {
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
}

#Preview {
    LoginView()
        .withPreviewEnvironment()
}
