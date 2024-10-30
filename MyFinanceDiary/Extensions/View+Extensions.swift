import SwiftUI

extension View {
    func greenGradientBackground() -> some View {
        self.background(Color.greenGradient)
    }
}

extension View {
    func popoverSheet<Content: View>(
        isPresented: Binding<Bool>,
        width: CGFloat = 300,
        height: CGFloat = 280,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        modifier(PopoverSheetModifier(
            isPresented: isPresented,
            width: width,
            height: height,
            content: content
        ))
    }
} 
