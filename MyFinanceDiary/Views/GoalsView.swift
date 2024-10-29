import SwiftUI
import Inject

struct GoalsView: View {
    @ObserveInjection var inject
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        ViewBuilderWrapper {
            // Header
            GoalsHeaderView()
        } main: {
            // Goals Cards
            GoalsCardsView()
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
        .navigationTitle("Goals")
    }
}

// MARK: - Header Component
private struct GoalsHeaderView: View {
    var body: some View {
        VStack(spacing: 8) {
            Circle()
                .fill(Color.white)
                .frame(width: 60, height: 60)
                .overlay(
                    Image(systemName: "trophy.fill")
                        .font(.system(size: 30))
                        .foregroundColor(.green)
                )
            
            Text("Your goals")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text("Stay on top of your financial")
                .font(.subheadline)
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity, minHeight: 300)
        .padding()
        .background(
            LinearGradient(
                colors: [Color(hex: "1D7B6E"), Color(hex: "1A9882")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
    }
}

// MARK: - Cards Component
private struct GoalsCardsView: View {
    var body: some View {
        // Goals Cards
        VStack(spacing: 16) {
            // Down Payment Goal Card
            GoalCard(
                title: "Save for a down payment 🏠",
                subtitle: "You're set to save $4,300 a month",
                progress: 0.23,
                currentValue: "$1,000",
                targetValue: "of $4,300",
                totalProgress: "Total savings: $1,000 of $60,000"
                    )
                    
            // Credit Score Goal Card
            GoalCard(
                title: "Boost my credit score",
                subtitle: "You're set to improve your score",
                progress: 0.85,
                currentValue: "733",
                targetValue: "750",
                totalProgress: "Your credit score goal: 750"
            )
        }
        .padding()
    }
}

struct GoalCard: View {
    let title: String
    let subtitle: String
    let progress: Double
    let currentValue: String
    let targetValue: String
    let totalProgress: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
            
            Text(subtitle)
                .font(.subheadline)
                .foregroundColor(.green)
            
            ProgressView(value: progress)
                .tint(.green)
            
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
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
    }
}

#Preview {
    GoalsView()
}
