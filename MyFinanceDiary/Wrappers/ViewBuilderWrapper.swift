import SwiftUI
import Inject

struct ViewBuilderWrapper<Header: View, Main: View, ToolbarContent: View>: View {
    @ObserveInjection var inject
    
    private let header: (() -> Header)
    private let main: (() -> Main)
    private let spacing: CGFloat
    private let backgroundColor: Color
    private let toolbarContent: (() -> ToolbarContent)?
    private let ignoreSafeArea: Bool
    
    // All components
    init(
        spacing: CGFloat = 24,
        backgroundColor: Color = .clear,
        ignoreSafeArea: Bool = true,
        @ViewBuilder header: @escaping () -> Header,
        @ViewBuilder main: @escaping () -> Main,
        @ViewBuilder toolbarContent: @escaping () -> ToolbarContent = { EmptyView() }
    ) {
        self.header = header
        self.main = main
        self.toolbarContent = toolbarContent
        self.spacing = spacing
        self.backgroundColor = backgroundColor
        self.ignoreSafeArea = ignoreSafeArea
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: spacing) {
                    header()
                    main()
                }
                .background(backgroundColor)
            }
            .ignoresSafeArea(edges: ignoreSafeArea ? .top : [])
            .toolbar {
                if let toolbarContent {
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        toolbarContent()
                    }
                }
            }
        }
        .enableInjection()
    }
}

#Preview {
    Group {
        ViewBuilderWrapper(
            header: { Text("Header") },
            main: { Text("Main") },
            toolbarContent: { Button("Action") {} }
        )
    }
}
