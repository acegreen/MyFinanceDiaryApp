import Inject
import SwiftUI

struct SettingsView: View {
    @ObserveInjection var inject
    @EnvironmentObject var appState: AppState
    @State private var showMenu: Bool = false

    var body: some View {
        SettingsMainView()
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbarBackground(Color.darkGreen, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    BackButton()
                }
                ToolbarItem(placement: .principal) {
                    EmptyView()
                }
            }
            .enableInjection()
    }
}

// MARK: - Settings Main Component

private struct SettingsMainView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                CardView {
                    VStack(spacing: 0) {
                        NavigationLink(destination: EmptyView()) {
                            SettingsMenuRow(title: "Support & FAQs",
                                            icon: "questionmark.circle.fill",
                                            iconColor: .darkGray)
                        }

                        Divider()

                        NavigationLink(destination: EmptyView()) {
                            SettingsMenuRow(title: "Review or Rate the App",
                                            subtitle: "Share the love",
                                            icon: "heart.fill",
                                            iconColor: .alertRed)
                        }

                        Divider()

                        NavigationLink(destination: EmptyView()) {
                            SettingsMenuRow(title: "Share Reminted App",
                                            subtitle: "Send a link to your friends",
                                            icon: "square.and.arrow.up.fill",
                                            iconColor: .darkGreen)
                        }
                    }
                }
            }
            .padding()
        }
        .scrollIndicators(.hidden)
    }
}

struct SettingsMenuRow: View {
    let title: String
    var subtitle: String? = nil
    let icon: String
    let iconColor: Color

    var body: some View {
        HStack(spacing: 20) {
            Image(systemName: icon)
                .foregroundColor(iconColor)
                .font(.system(size: 32))

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.body)

                if let subtitle {
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
                .font(.system(size: 14))
        }
        .padding()
    }
}

#Preview {
    SettingsView()
        .withPreviewEnvironment()
}
