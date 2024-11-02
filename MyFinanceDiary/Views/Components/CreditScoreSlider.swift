import Inject
import SwiftUI

struct CreditScoreSlider: View {
    let creditScore: Int
    let height: CGFloat

    init(creditScore: Int = 0,
         height: CGFloat = 12)
    {
        self.creditScore = creditScore
        self.height = height
    }

    // Constants for score range
    private let minScore = 300
    private let maxScore = 850

    var scoreStatus: String {
        switch creditScore {
        case minScore ... 579: return "Poor"
        case 580 ... 669: return "Fair"
        case 670 ... 739: return "Good"
        case 740 ... 799: return "Very Good"
        default: return "Excellent"
        }
    }

    var statusColor: Color {
        switch creditScore {
        case minScore ... 579: return .alertRed
        case 580 ... 669: return .vibrantOrange
        case 670 ... 739: return .softYellow
        case 740 ... 799: return .primaryGreen
        default: return .primaryGreen
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Status indicator
            GeometryReader { geometry in
                let offset = calculateScoreOffset(in: geometry.size.width)

                HStack {
                    Spacer()
                    VStack(spacing: 2) {
                        Text(scoreStatus)
                            .font(.subheadline.bold())
                            .foregroundColor(.white)
                        Image(systemName: "triangle.fill")
                            .font(.system(size: 12))
                            .foregroundColor(statusColor)
                            .rotationEffect(.degrees(180))
                    }
                    Spacer()
                }
                .offset(x: offset)
            }
            .frame(height: 30)

            // Gradient slider
            GeometryReader { _ in
                LinearGradient(
                    colors: [.alertRed, .vibrantOrange, .softYellow, .primaryGreen],
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .cornerRadius(height / 2)
            }
            .frame(height: height)

            // Score labels
            HStack {
                Text("\(minScore)")
                Spacer()
                Text("500")
                Spacer()
                Text("600")
                Spacer()
                Text("700")
                Spacer()
                Text("\(maxScore)")
            }
            .font(.subheadline.bold())
            .foregroundColor(.white)
        }
    }

    private func calculateScoreOffset(in width: CGFloat) -> CGFloat {
        // Calculate percentage position (0 to 1)
        let percentage = CGFloat(creditScore - minScore) / CGFloat(maxScore - minScore)

        // Calculate absolute position
        let position = width * percentage

        // Adjust for the HStack's Spacer() which centers the indicator
        return position - (width / 2)
    }
}

#Preview {
    CreditScoreSlider(creditScore: 821)
        .padding()
}
