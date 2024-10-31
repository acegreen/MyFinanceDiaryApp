import SwiftUI
import Inject

struct MeView: View {
    @ObserveInjection var inject
    @EnvironmentObject var appState: AppState
    @State private var showMenu: Bool = false

    var body: some View {
        ViewBuilderWrapper {
            MeHeaderView()
        } main: {
            MeMainView()
        } toolbarContent: {
            Button {
                showMenu.toggle()
            } label: {
                Image(systemName: "line.3.horizontal")
                    .foregroundColor(.white)
            }
            .popoverSheet(isPresented: $showMenu) {
                MenuView()
            }
        }
        .navigationTitle("Me")
        .enableInjection()
    }
}

// MARK: - Header Component
private struct MeHeaderView: View {
    var body: some View {
        VStack(spacing: 8) {
            Circle()
                .fill(Color.white)
                .frame(width: 100, height: 100)
                .overlay(
                    Image(systemName: "person.circle.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.darkGreen)
                )
                .shadow(radius: 2)

            VStack(spacing: 8) {
                Text("John Doe")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
        }
        .padding(.top, 48)
        .frame(maxWidth: .infinity, minHeight: 300)
        .greenGradientBackground()
    }
}

// MARK: - Main Content Component
private struct MeMainView: View {
    var body: some View {
        VStack(spacing: 16) {
            MenuView()
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        }
        .padding()
    }
}
