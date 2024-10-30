import SwiftUI

extension Color {
    static let primaryGreen = Color(hex: "#00C241") // Correct primary green
    static let darkGreen = Color(hex: "#009900")
    static let lightGreen = Color(hex: "#66B24A") // Further adjusted light green
    static let neutralGray = Color(hex: "#F2F2F2")
    static let darkGray = Color(hex: "#333333")
    static let accentBlue = Color(hex: "#1DA1F2")
    static let softYellow = Color(hex: "#FFD700")
    static let alertRed = Color(hex: "#FF3B30")
    static let vibrantOrange = Color(hex: "#FF6F30") // Vibrant orange

    // Gradient from base color to a lighter shade
    static let greenGradient = LinearGradient(
        gradient: Gradient(colors: [darkGreen, lightGreen]),
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
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
