import SwiftUI
import Inject

struct GoalsView: View {
    @ObserveInjection var inject
    @EnvironmentObject var appState: AppState
    @State private var showMenu: Bool = false

    var body: some View {
        ViewBuilderWrapper {
            GoalsHeaderView()
        } main: {
            GoalsMainView()
        } toolbarContent: {
            Button {
                showMenu.toggle()
            } label: {
                Image(systemName: "line.3.horizontal")
                .foregroundColor(.white)
            }
            .popoverSheet(isPresented: $showMenu) {
                MenuView()
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
                .frame(width: 100, height: 100)
                .overlay(
                    Image(systemName: "trophy.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.darkGreen)
                )
            
            Text("Your goals")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text("Stay on top of your financial")
                .font(.headline)
                .foregroundColor(.white)
        }
        .padding(.top, 48)
        .frame(maxWidth: .infinity, minHeight: 300)
        .greenGradientBackground()
    }
}

// MARK: - Cards Component
private struct GoalsMainView: View {
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

#Preview {
    GoalsView()
}
