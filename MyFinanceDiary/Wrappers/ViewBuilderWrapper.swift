import SwiftUI
import Inject

struct ViewBuilderWrapper<Header: View, Main: View>: View {
    @ObserveInjection var inject
    
    private let header: Header
    private let main: Main
    private let spacing: CGFloat
    private let backgroundColor: Color
    private let toolbarItems: () -> AnyView
    private let ignoreSafeArea: Bool
    
    init(
        spacing: CGFloat = 24,
        backgroundColor: Color = .clear,
        ignoreSafeArea: Bool = true,
        @ViewBuilder header: () -> Header,
        @ViewBuilder main: () -> Main,
        @ViewBuilder toolbarContent: @escaping () -> some View
    ) {
        self.header = header()
        self.main = main()
        self.spacing = spacing
        self.backgroundColor = backgroundColor
        self.toolbarItems = { AnyView(toolbarContent()) }
        self.ignoreSafeArea = ignoreSafeArea
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
            .ignoresSafeArea(edges: ignoreSafeArea ? .top : [])
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
