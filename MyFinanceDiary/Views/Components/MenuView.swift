import SwiftUI
import Inject

struct MenuView: View {
    @ObserveInjection var inject
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            MenuRow(title: "Review or Rate the App",
                    subtitle: "Share the love",
                    icon: "heart.fill",
                    iconColor: .alertRed)
            
            Divider()
            
            MenuRow(title: "App Settings",
                    icon: "gearshape.fill",
                    iconColor: .darkGray)
            
            Divider()
            
            MenuRow(title: "Support & FAQs",
                    icon: "questionmark.circle.fill",
                    iconColor: .darkGray)
            
            Divider()
            
            MenuRow(title: "Share MyFinanceDiary App",
                    subtitle: "Send a link to your friends",
                    icon: "square.and.arrow.up.fill",
                    iconColor: .darkGreen)
        }
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
                
                if let subtitle {
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }

            Spacer()
            
            Image(systemName: icon)
                .foregroundColor(iconColor)
        }
        .padding(16)
    }
} 