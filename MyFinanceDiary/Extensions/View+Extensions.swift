import SwiftUI

extension View {
    func greenGradientBackground() -> some View {
        background(Color.greenGradient)
    }
}

extension View {
    @ViewBuilder
    func addShadow() -> some View {
        shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
    }
}

extension View {
    func popoverSheet<Content: View>(
        isPresented: Binding<Bool>,
        width: CGFloat = 300,
        height: CGFloat = 280,
        @ViewBuilder content: @escaping (_ height: CGFloat) -> Content
    ) -> some View {
        modifier(PopoverSheetModifier(
            isPresented: isPresented,
            width: width,
            height: height,
            content: content
        ))
    }
}
