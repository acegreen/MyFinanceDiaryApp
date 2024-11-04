import SwiftUI

struct ChangeIndicatorView: View {
    let isPositive: Bool
    let description: String
    let textColor: Color
    
    init(
        isPositive: Bool,
        description: String,
        textColor: Color = .white
    ) {
        self.isPositive = isPositive
        self.description = description
        self.textColor = textColor
    }
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: isPositive ? "arrow.up" : "arrow.down")
                .foregroundColor(.white)
                .padding(4)
                .background(
                    Circle()
                        .fill(isPositive ? Color.primaryGreen : .alertRed)
                )
                .frame(width: 24, height: 24)
            Text(description)
                .font(.headline)
                .foregroundColor(textColor)
        }
    }
} 
