import SwiftUI

extension Color {
    // Primary Colors
    static let primaryGreen = Color(hex: "#00C241") // Financial growth and prosperity
    static let darkGreen = Color(hex: "#007A33") // Emphasis and contrast
    static let lightGreen = Color(hex: "#66D17A") // Backgrounds or highlights

    // Grays for Neutrality and Readability
    static let neutralGray = Color(hex: "#E0E0E0") // Backgrounds, dividers
    static let darkGray = Color(hex: "#4A4A4A") // Primary text
    static let softGray = Color(hex: "#F2F2F2") // Very light backgrounds

    // Accent Colors
    static let accentBlue = Color(hex: "#1E88E5") // Interactive elements
    static let softYellow = Color(hex: "#FFDD57") // Gentle highlights or notifications
    static let vibrantOrange = Color(hex: "#FF7043") // Attention-grabbing badges or buttons

    // Alert Colors
    static let alertRed = Color(hex: "#E53935") // Alerts or warnings

    // Copper Accent (for decorative elements)
    static let copperAccent = Color(hex: "#B87333") // Metallic hint for finance theme

    // Gradient from Dark Green to Light Green
    static let greenGradient = LinearGradient(
        gradient: Gradient(colors: [darkGreen, primaryGreen, lightGreen]),
        startPoint: .top,
        endPoint: .bottom
    )
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
