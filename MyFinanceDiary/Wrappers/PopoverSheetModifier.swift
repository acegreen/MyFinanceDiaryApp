import SwiftUI

struct PopoverSheetModifier<SheetContent: View>: ViewModifier {
    let isPresented: Binding<Bool>
    let width: CGFloat
    let height: CGFloat
    let sheetContent: () -> SheetContent
    @State private var sourceRect: CGRect = .zero
    
    init(
        isPresented: Binding<Bool>,
        width: CGFloat = 300,
        height: CGFloat = 280,
        @ViewBuilder content: @escaping () -> SheetContent
    ) {
        self.isPresented = isPresented
        self.width = width
        self.height = height
        self.sheetContent = content
    }
    
    func body(content: Content) -> some View {
        content
            .popover(
                isPresented: isPresented,
                attachmentAnchor: .rect(.bounds),
                arrowEdge: .top
            ) {
                sheetContent()
                    .frame(width: width, height: height)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .presentationCompactAdaptation(.popover)
            }
    }
}