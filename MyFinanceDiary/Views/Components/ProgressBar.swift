import SwiftUI

struct ProgressBar: View {
    let progress: Double
    let height: CGFloat
    
    init(progress: Double, height: CGFloat = 6) {
        self.progress = progress
        self.height = height
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .foregroundColor(.gray.opacity(0.3))

                Rectangle()
                    .frame(width: geometry.size.width * progress)
                    .foregroundColor(.green)
            }
        }
        .frame(height: height)
        .cornerRadius(height / 2)
    }
}
