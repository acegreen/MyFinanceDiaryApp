import SwiftUI

extension View {
    func greenGradientBackground() -> some View {
        self.background(Color.greenGradient)
    }
}

extension View {
    @ViewBuilder
    func addShadow() -> some View {
        self.shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
    }
}

extension View {
    @ViewBuilder
    func makeCard() -> some View {
        self.background(Color(uiColor: .systemBackground))
            .cornerRadius(12)
            .addShadow()
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
