import Inject
import SwiftUI

struct GoalCard: View {
    let title: String
    let subtitle: String
    let progress: Double
    let currentValue: String
    let targetValue: String
    let totalProgress: String

    var body: some View {
        CardView {
            VStack(alignment: .leading, spacing: 12) {
                Text(title)
                    .font(.headline)

                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.darkGreen)

                ProgressBar(value: progress)

                HStack {
                    Text(currentValue)
                        .fontWeight(.semibold)

                    Spacer()

                    Text(targetValue)
                        .foregroundColor(.secondary)
                }
                .font(.subheadline)

                Text(totalProgress)
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
            .padding()
        }
    }
}
