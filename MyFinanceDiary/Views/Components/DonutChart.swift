import Inject
import SwiftUI

struct DonutChart: View {
    @ObserveInjection var inject
    let budget: Budget
    let animate: Bool
    private let lineWidth: CGFloat = 25

    var body: some View {
        ZStack {
            // Background circle
            Circle()
                .stroke(Color.white.opacity(0.5), lineWidth: lineWidth)

            // Segments
            ForEach(budget.expenseCategories.indices, id: \.self) { index in
                let startAngle = self.startAngle(for: index)
                let endAngle = self.endAngle(for: index)

                Circle()
                    .trim(from: startAngle, to: animate ? endAngle : startAngle)
                    .stroke(budget.expenseCategories[index].color, lineWidth: lineWidth)
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut(duration: 0.5).delay(Double(index) * 0.05), value: animate)
            }

            // Center content
            VStack(spacing: 4) {
                Text("$\(Int(animate ? budget.summary.totalSpent : 0))")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                    .animation(.easeInOut(duration: 0.5), value: animate)

                Text("of $\(Int(budget.summary.totalBudget))")
                    .font(.headline)
                    .foregroundColor(.white)
            }
        }
        .frame(height: 200)
        .enableInjection()
    }

    private func startAngle(for index: Int) -> Double {
        if index == 0 { return 0 }

        let previousSegments = budget.expenseCategories[..<index]
        let totalPreviousAmount = previousSegments.reduce(0) { $0 + $1.spent }
        return totalPreviousAmount / budget.summary.totalBudget
    }

    private func endAngle(for index: Int) -> Double {
        let previousSegments = budget.expenseCategories[...index]
        let totalPreviousAmount = previousSegments.reduce(0) { $0 + $1.total }
        return totalPreviousAmount / budget.summary.totalBudget
    }
}
