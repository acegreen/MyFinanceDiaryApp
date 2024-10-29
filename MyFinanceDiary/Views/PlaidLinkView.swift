import SwiftUI
import Inject

struct PlaidLinkView: View {
    @ObserveInjection var inject
    @StateObject private var plaidService = PlaidService()
    @Binding var isPresented: Bool

    var body: some View {
        NavigationView {
            VStack {
                if plaidService.isLoading {
                    ProgressView()
                } else if let _ = plaidService.handler {
                    Color.clear
                        .onAppear {
                            print("Ready to present Plaid Link")
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                plaidService.presentPlaidLink(from: UIApplication.shared.rootViewController())
                            }
                        }
                } else if plaidService.error != nil {
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
            plaidService.setupPlaidLink()
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
