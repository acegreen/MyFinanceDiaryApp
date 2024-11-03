import Inject
import SwiftUI

struct DonutChart: View {
    @ObserveInjection var inject
    let segments: [(category: TransactionCategory, amount: Double)]
    let totalBudget: Double
    let spent: Double

    private let lineWidth: CGFloat = 25

    // Color mapping for categories
    private func color(for category: TransactionCategory) -> Color {
        switch category {
        case .foodAndDrink, .restaurants, .fastFood, .coffeeShop:
            return .orange
        case .shopping, .shops, .sportingGoods:
            return .blue
        case .travel, .transportation, .taxi, .airlinesAndAviation:
            return .green
        case .entertainment, .recreation:
            return .purple
        case .rent, .utilities:
            return .red
        case .healthcare, .service:
            return .pink
        case .deposit, .payroll:
            return .mint
        case .creditCard, .payment, .transfer:
            return .indigo
        default:
            return .gray
        }
    }

    var body: some View {
        ZStack {
            // Background circle
            Circle()
                .stroke(Color.gray.opacity(0.2), lineWidth: lineWidth)

            // Segments
            ForEach(segments.indices, id: \.self) { index in
                let startAngle = self.startAngle(for: index)
                let endAngle = self.endAngle(for: index)

                Circle()
                    .trim(from: startAngle, to: endAngle)
                    .stroke(color(for: segments[index].category), lineWidth: lineWidth)
                    .rotationEffect(.degrees(-90))
            }

            // Center content
            VStack(spacing: 4) {
                Text("$\(Int(spent))")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)

                Text("of $\(Int(totalBudget))")
                    .font(.headline)
                    .foregroundColor(.white)
            }
        }
        .frame(height: 200)
        .enableInjection()
    }

    private func startAngle(for index: Int) -> Double {
        if index == 0 { return 0 }

        let previousSegments = segments[..<index]
        let totalPreviousAmount = previousSegments.reduce(0) { $0 + $1.amount }
        return totalPreviousAmount / totalBudget
    }

    private func endAngle(for index: Int) -> Double {
        let previousSegments = segments[...index]
        let totalPreviousAmount = previousSegments.reduce(0) { $0 + $1.amount }
        return totalPreviousAmount / totalBudget
    }
}
