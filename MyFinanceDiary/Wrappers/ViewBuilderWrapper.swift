import SwiftUI
import Inject

struct ViewBuilderWrapper<Header: View, Main: View>: View {
    @ObserveInjection var inject
    
    private let header: Header
    private let main: Main
    private let spacing: CGFloat
    private let backgroundColor: Color
    private let toolbarItems: () -> AnyView
    
    init(
        spacing: CGFloat = 24,
        backgroundColor: Color = .clear,
        @ViewBuilder header: () -> Header,
        @ViewBuilder main: () -> Main,
        @ViewBuilder toolbarContent: @escaping () -> some View
    ) {
        self.header = header()
        self.main = main()
        self.spacing = spacing
        self.backgroundColor = backgroundColor
        self.toolbarItems = { AnyView(toolbarContent()) }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: spacing) {
                    header
                    main
                }
                .background(backgroundColor)
            }
            .ignoresSafeArea(edges: .top) // Only ignore top safe area
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    toolbarItems()
                }
            }
        }
        .enableInjection()
    }
}
