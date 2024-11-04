import Inject
import SwiftUI

// Helper Views
struct CardView<Content: View>: View {
    @ObserveInjection var inject
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .background {
                Color(uiColor: .systemBackground)
                    .cornerRadius(12)
                    .addShadow()
            }
            .enableInjection()
    }
}
