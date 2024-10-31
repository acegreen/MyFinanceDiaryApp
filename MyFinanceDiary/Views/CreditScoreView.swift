import SwiftUI
import Inject

struct CreditScoreView: View {
    @ObserveInjection var inject
    @EnvironmentObject var appState: AppState

    var body: some View {
        ViewBuilderWrapper {
            CreditScoreHeaderView(
                creditScore: appState.creditScoreViewModel.creditScore,
                lastUpdated: appState.creditScoreViewModel.lastUpdated,
                scoreChange: appState.creditScoreViewModel.scoreChange,
                changeDescription: appState.creditScoreViewModel.changeDescription
            )
        } main: {
            CreditScoreMainView(metrics: appState.creditScoreViewModel.metrics)
        }
    }
}

struct CreditScoreHeaderView: View {
    let creditScore: Int
    let lastUpdated: String
    let scoreChange: Int
    let changeDescription: String

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            // Credit Score Section
            VStack(alignment: .leading, spacing: 8) {
                Text("Credit score")
                    .font(.title)
                    .foregroundColor(.white)

                Text("\(creditScore)")
                    .font(.system(size: 48, weight: .bold))
                    .foregroundColor(.white)

                ChangeIndicatorView(
                    isPositive: scoreChange > 0,
                    description: changeDescription
                )

                CreditScoreSlider(creditScore: creditScore)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 300)
        .greenGradientBackground()
    }
}

struct CreditScoreMainView: View {
    let metrics: [CreditScoreViewModel.CreditMetric]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Credit score breakdown")
                .font(.headline)

            VStack(spacing: 24) {
                ForEach(metrics, id: \.title) { metric in
                    CreditMetricRow(
                        title: metric.title,
                        value: metric.value,
                        status: metric.status,
                        statusColor: metric.statusColor,
                        detail: metric.detail
                    )
                }
            }
        }
        .padding()
    }
}

struct CreditMetricRow: View {
    let title: String
    let value: String
    let status: String
    let statusColor: Color
    var detail: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(title)
                Spacer()
                Text(value)
            }
            .font(.body)

            HStack {
                Text(status)
                    .foregroundColor(statusColor)
                if let detail = detail {
                    Spacer()
                    Text(detail)
                        .foregroundColor(.secondary)
                }
            }
            .font(.subheadline)

            Divider()
        }
    }
}

#Preview {
    CreditScoreView()
}
