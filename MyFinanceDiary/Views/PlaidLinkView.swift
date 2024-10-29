import SwiftUI
import Inject

struct PlaidLinkView: View {
    @ObserveInjection var inject
    @EnvironmentObject var appState: AppState
    @Binding var isPresented: Bool

    var body: some View {
        NavigationView {
            VStack {
                if appState.plaidService.isLoading {
                    ProgressView()
                } else if let _ = appState.plaidService.handler {
                    Color.clear
                        .onAppear {
                            print("Ready to present Plaid Link")
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                appState.plaidService.presentPlaidLink(from: UIApplication.shared.rootViewController())
                            }
                        }
                } else if appState.plaidService.error != nil {
                    Text("Unable to load Plaid Link")
                        .foregroundColor(.red)
                }
            }
            .navigationTitle("Connect Bank")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }
            }
        }
        .onAppear {
            print("PlaidLinkView appeared")
            appState.plaidService.setupPlaidLink()
        }
        .enableInjection()
    }
}

// Add this extension to help get the root view controller
extension UIApplication {
    func rootViewController() -> UIViewController {
        guard let windowScene = connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController
        else {
            return UIViewController()
        }
        return rootViewController
    }
} 
