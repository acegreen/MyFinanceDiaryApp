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
                scoreChange: appState.creditScoreViewModel.scoreChange
            )
        } main: {
            CreditScoreMainView(metrics: appState.creditScoreViewModel.metrics)
        } toolbarContent: {
            Button(action: {}) {
                Image(systemName: "bubble.and.pencil")
                    .foregroundColor(.white)
            }
            Button(action: {}) {
                Image(systemName: "plus")
                    .foregroundColor(.white)
            }
        }
    }
}

struct CreditScoreHeaderView: View {
    let creditScore: Int
    let lastUpdated: String
    let scoreChange: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            // Credit Score Section
            VStack(alignment: .leading, spacing: 8) {
                    Text("Credit score")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Text("\(creditScore)")
                    .font(.system(size: 48, weight: .bold))
                    .foregroundColor(.white)
                
                HStack(spacing: 4) {
                    Image(systemName: "arrow.up.circle.fill")
                            .foregroundColor(.green)
                        Text("+\(scoreChange) pts on \(lastUpdated)")
                            .font(.subheadline)
                            .foregroundColor(.white)
                    }

                    CreditScoreSlider(creditScore: creditScore)
                }
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 300)
        .background(
            LinearGradient(
                colors: [Color(hex: "1D7B6E"), Color(hex: "1A9882")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
    }
}

struct CreditScoreMainView: View {
    let metrics: [CreditMetric]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Credit score breakdown")
                .font(.headline)
            
            VStack(spacing: 24) {
                ForEach(metrics, id: \.title) { metric in
                    CreditMetricRowUpdated(
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

struct CreditScoreSlider: View {
    let creditScore: Int
    
    // Constants for score range
    private let minScore = 300
    private let maxScore = 850
    
    var scoreStatus: String {
        switch creditScore {
        case minScore...579: return "Poor"
        case 580...669: return "Fair"
        case 670...739: return "Good"
        case 740...799: return "Very Good"
        default: return "Excellent"
        }
    }
    
    var statusColor: Color {
        switch creditScore {
        case minScore...579: return .red
        case 580...669: return .orange
        case 670...739: return .green
        case 740...799: return .green
        default: return .green
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Status indicator
            GeometryReader { geometry in
                let offset = calculateScoreOffset(in: geometry.size.width)
                
                HStack {
                    Spacer()
                    VStack(spacing: 2) {
                        Text(scoreStatus)
                            .font(.subheadline)
                            .foregroundColor(statusColor)
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
            GeometryReader { geometry in
                LinearGradient(
                    colors: [.red, .orange, .yellow, .green],
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .frame(height: 12)
                .cornerRadius(6)
            }
            .frame(height: 12)
            
            // Score labels
            HStack {
                Text("400")
                Spacer()
                Text("500")
                Spacer()
                Text("600")
                Spacer()
                Text("700")
                Spacer()
                Text("850")
            }
            .font(.subheadline)
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

struct CreditMetricRowUpdated: View {
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
