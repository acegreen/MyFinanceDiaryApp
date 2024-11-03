import SwiftUI

struct CircularProgressView: View {
    let progress: Double

    var body: some View {
        Circle()
            .trim(from: 0, to: progress)
            .stroke(Color.darkGreen, lineWidth: 8)
            .rotationEffect(.degrees(-90))
    }
}
