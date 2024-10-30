import SwiftUI
import Inject

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
                .foregroundColor(.darkGreen)

            ProgressView(value: progress)
                .tint(.darkGreen)

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