import Inject
import SwiftUI

struct MenuView: View {
    @ObserveInjection var inject
    @Environment(\.dismiss) var dismiss
    let height: CGFloat
    @Binding var navigationPath: NavigationPath

    enum MenuDestination: Hashable {
        case settings
        case support
        case review
        case share
    }

    var body: some View {
        VStack(spacing: 0) {
            Button {
                dismiss()
                navigationPath.append(MenuDestination.settings)
            } label: {
                MenuRow(title: "App Settings",
                        icon: "gearshape.fill",
                        iconColor: .darkGray)
            }
            Divider()

            Button {
                dismiss()
                navigationPath.append(MenuDestination.support)
            } label: {
                MenuRow(title: "Support & FAQs",
                        icon: "questionmark.circle.fill",
                        iconColor: .darkGray)
            }
            Divider()

            Button {
                dismiss()
                navigationPath.append(MenuDestination.review)
            } label: {
                MenuRow(title: "Review or Rate the App",
                        subtitle: "Share the love",
                        icon: "heart.fill",
                        iconColor: .alertRed)
            }
            Divider()

            Button {
                dismiss()
                navigationPath.append(MenuDestination.share)
            } label: {
                MenuRow(title: "Share Reminted App",
                        subtitle: "Send a link to your friends",
                        icon: "square.and.arrow.up.fill",
                        iconColor: .darkGreen)
            }
        }
        .frame(height: height)
        .enableInjection()
    }
}

struct MenuRow: View {
    let title: String
    var subtitle: String? = nil
    let icon: String
    let iconColor: Color

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.body)
                    .foregroundColor(.primaryGreen)

                if let subtitle {
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }

            Spacer()

            Image(systemName: icon)
                .foregroundColor(iconColor)
        }
        .padding(16)
    }
}
