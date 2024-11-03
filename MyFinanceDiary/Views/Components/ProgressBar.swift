import SwiftUI

struct ProgressBar<Shape: SwiftUI.Shape>: View {
    let value: Double
    let shape: Shape
    let height: CGFloat
    let color: Color

    init(
        value: Double,
        shape: Shape,
        height: CGFloat = 8,
        color: Color = .darkGreen
    ) {
        self.value = min(max(value, 0), 1) // Clamp value between 0 and 1
        self.shape = shape
        self.height = height
        self.color = color
    }

    var body: some View {
        shape
            .fill(Color.neutralGray)
            .overlay(alignment: .leading) {
                GeometryReader { proxy in
                    shape
                        .fill(color)
                        .frame(width: proxy.size.width * value)
                }
            }
            .frame(height: height)
            .clipShape(shape)
    }
}

extension ProgressBar where Shape == RoundedRectangle {
    init(
        value: Double,
        height: CGFloat = 8,
        color: Color = .darkGreen
    ) {
        self.init(
            value: value,
            shape: RoundedRectangle(cornerRadius: height / 2),
            height: height,
            color: color
        )
    }
}

#Preview {
    ProgressBar(value: 0.7)
}
