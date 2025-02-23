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
        HStack(spacing: 8) {
            Image(systemName: isPositive ? "arrow.up" : "arrow.down")
                .foregroundColor(.darkGreen)
                .padding(4)
                .background(
                    Circle()
                        .fill(.white)
                )
                .frame(width: 24, height: 24)
            Text(description)
                .font(.headline)
                .foregroundColor(textColor)
        }
    }
} 
