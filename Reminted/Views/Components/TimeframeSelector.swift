import Inject
import SwiftUI

struct TimeframeSelector: View {
    @ObserveInjection var inject
    @Binding var selectedTimeframe: Timeframe

    enum Timeframe: String, CaseIterable {
        case week = "7D"
        case month = "30D"
        case year = "1Y"
        case all = "All"
    }

    var body: some View {
        HStack(spacing: 0) {
            ForEach(Timeframe.allCases, id: \.self) { timeframe in
                Button {
                    selectedTimeframe = timeframe
                } label: {
                    Text(timeframe.rawValue)
                        .font(.subheadline)
                        .padding(.vertical, 8)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.white)
                        .background {
                            if selectedTimeframe == timeframe {
                                Capsule()
                                    .fill(.white.opacity(0.3))
                            }
                        }
                }
            }
        }
        .padding(4)
        .background {
            Capsule()
                .fill(Color.darkGreen.opacity(0.3))
        }
        .padding(.horizontal)
        .enableInjection()
    }
}
