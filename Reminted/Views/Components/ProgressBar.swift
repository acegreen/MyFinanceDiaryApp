import SwiftUI

struct ProgressBar<Shape: SwiftUI.Shape>: View {
    let value: Double
    let shape: Shape
    let height: CGFloat
    let color: Color
    let animate: Bool

    init(
        value: Double,
        shape: Shape,
        height: CGFloat = 8,
        color: Color = .darkGreen,
        animate: Bool = false
    ) {
        self.value = min(max(value, 0), 1)
        self.shape = shape
        self.height = height
        self.color = color
        self.animate = animate
    }

    var body: some View {
        shape
            .fill(Color.neutralGray)
            .overlay(alignment: .leading) {
                GeometryReader { proxy in
                    shape
                        .fill(color)
                        .frame(width: proxy.size.width * (animate ? value : 0))
                        .animation(.easeInOut(duration: 1.0), value: animate)
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
        color: Color = .darkGreen,
        animate: Bool = false
    ) {
        self.init(
            value: value,
            shape: RoundedRectangle(cornerRadius: height / 2),
            height: height,
            color: color,
            animate: animate
        )
    }
}

#Preview {
    ProgressBar(value: 0.7)
}
