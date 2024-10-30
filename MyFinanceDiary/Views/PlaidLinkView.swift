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
                } else if let _ = appState.plaidService.handler, !appState.plaidService.isPresenting {
                    Color.clear
                        .onAppear {
                            print("Ready to present Plaid Link")
                            appState.plaidService.presentPlaidLink(from: UIApplication.shared.rootViewController())
                        }
                } else if let error = appState.plaidService.error {
                    Text("Unable to load Plaid Link: \(error.localizedDescription)")
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
            guard !appState.plaidService.isPresenting else { return }
            appState.plaidService.setupPlaidLink()
        }
        .enableInjection()
    }
}