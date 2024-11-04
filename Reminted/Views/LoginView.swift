import Inject
import SwiftUI

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
        VStack(spacing: 24) {
            VStack(spacing: 0) {
                Image(.appIcon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)

                Text("Reminted")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
            }

            VStack(spacing: 24) {
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

                Spacer()

                Text("By logging in, you agree to our Privacy Policy and Terms of Service. \nAll content is protected by copyright © 2024")
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(24)
        // .offset(y: -60)
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
