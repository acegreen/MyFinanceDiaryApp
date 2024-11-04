import Inject
import SwiftUI

struct ViewBuilderWrapper<Header: View, Main: View, Background: ShapeStyle>: View {
    @ObserveInjection var inject

    let header: () -> Header
    let main: () -> Main
    let spacing: CGFloat
    let background: Background
    let scrollIndicatorVisibility: ScrollIndicatorVisibility
    let ignoreSafeArea: Bool

    init(
        spacing: CGFloat = 0,
        background: Background = Color(uiColor: .systemBackground),
        scrollIndicatorVisibility: ScrollIndicatorVisibility = .hidden,
        ignoreSafeArea: Bool = false,
        @ViewBuilder header: @escaping () -> Header,
        @ViewBuilder main: @escaping () -> Main
    ) {
        self.header = header
        self.main = main
        self.spacing = spacing
        self.background = background
        self.scrollIndicatorVisibility = scrollIndicatorVisibility
        self.ignoreSafeArea = ignoreSafeArea
    }

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: spacing) {
                    header()
                    main()
                }
                .padding(.top, ignoreSafeArea ? geometry.safeAreaInsets.top : 0)
            }
            .background(background)
            .clipped()
            .navigationBarBackButtonHidden(true)
            .toolbarBackground(ignoreSafeArea ? .hidden : .automatic, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .scrollIndicators(scrollIndicatorVisibility)
            .ignoresSafeArea(edges: ignoreSafeArea ? .top : Edge.Set())
        }
    }
}

#Preview {
    Group {
        ViewBuilderWrapper(
            header: { Text("Header") },
            main: { Text("Main") }
        )
    }
}
