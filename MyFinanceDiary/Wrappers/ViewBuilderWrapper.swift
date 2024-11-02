import Inject
import SwiftUI

struct ViewBuilderWrapper<Header: View, Main: View, ToolbarContent: View>: View {
    @ObserveInjection var inject

    private let header: () -> Header
    private let main: () -> Main
    private let scrollIndicatorVisibility: ScrollIndicatorVisibility
    private let spacing: CGFloat
    private let backgroundColor: Color
    private let toolbarContent: (() -> ToolbarContent)?
    private let ignoreSafeArea: Bool

    // All components
    init(
        scrollIndicatorVisibility: ScrollIndicatorVisibility = .hidden,
        spacing: CGFloat = 12,
        backgroundColor: Color = .clear,
        ignoreSafeArea: Bool = true,
        @ViewBuilder header: @escaping () -> Header,
        @ViewBuilder main: @escaping () -> Main,
        @ViewBuilder toolbarContent: @escaping () -> ToolbarContent = { EmptyView() }
    ) {
        self.header = header
        self.main = main
        self.toolbarContent = toolbarContent
        self.scrollIndicatorVisibility = scrollIndicatorVisibility
        self.spacing = spacing
        self.backgroundColor = backgroundColor
        self.ignoreSafeArea = ignoreSafeArea
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: spacing) {
                    header()
                    // .padding(.top, ignoreSafeArea ? 48 : 0)
                    main()
                }
                .background(backgroundColor)
            }
            .scrollIndicators(scrollIndicatorVisibility)
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
