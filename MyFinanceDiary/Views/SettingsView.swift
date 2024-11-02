import SwiftUI
import Inject

struct SettingsView: View {
    @ObserveInjection var inject
    @EnvironmentObject var appState: AppState
    @State private var showMenu: Bool = false

    var body: some View {
        ViewBuilderWrapper {
            SettingsHeaderView()
        } main: {
            SettingsMainView()
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
private struct SettingsHeaderView: View {
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
private struct SettingsMainView: View {
    var body: some View {
        VStack(spacing: 16) {
            VStack(spacing: 0) {
                SettingsMenuListRow(title: "Review or Rate the App",
                            subtitle: "Share the love",
                            icon: "heart.fill",
                            iconColor: .alertRed)
                
                Divider()
                
                SettingsMenuListRow(title: "App Settings",
                            icon: "gearshape.fill",
                            iconColor: .darkGray)
                
                Divider()
                
                SettingsMenuListRow(title: "Support & FAQs",
                            icon: "questionmark.circle.fill",
                            iconColor: .darkGray)
                
                Divider()
                
                SettingsMenuListRow(title: "Share MyFinanceDiary App",
                            subtitle: "Send a link to your friends",
                            icon: "square.and.arrow.up.fill",
                        iconColor: .darkGreen)
            }
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        }
        .padding()
    }
}

struct SettingsMenuListRow: View {
    let title: String
    var subtitle: String? = nil
    let icon: String
    let iconColor: Color
    
    var body: some View {
        NavigationLink(destination: EmptyView()) {
            HStack(spacing: 20) {
                Image(systemName: icon)
                    .foregroundColor(iconColor)
                    .font(.system(size: 30))

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.body)
                    
                    if let subtitle {
                        Text(subtitle)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }

                Spacer()
            }
            .padding(16)
        }
    }
} 

#Preview {
    SettingsView()
        .withPreviewEnvironment()
}
