import SwiftUI

struct ProgressBar: View {
    let progress: Double
    let height: CGFloat
    let color: Color
    
    init(progress: Double, height: CGFloat = 6, color: Color = .primaryGreen) {
        self.progress = progress
        self.height = height
        self.color = color
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .foregroundColor(.gray.opacity(0.3))

                Rectangle()
                    .frame(width: geometry.size.width * progress)
                    .foregroundColor(color)
            }
        }
        .frame(height: height)
        .cornerRadius(height / 2)
    }
}
