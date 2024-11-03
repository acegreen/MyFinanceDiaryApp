import Inject
import SwiftUI

struct ViewBuilderWrapper<Header: View, Main: View>: View {
    @ObserveInjection var inject

    let header: () -> Header
    let main: () -> Main
    let spacing: CGFloat
    let backgroundColor: Color
    let scrollIndicatorVisibility: ScrollIndicatorVisibility
    let ignoreSafeArea: Bool

    init(
        spacing: CGFloat = 0,
        backgroundColor: Color = .clear,
        scrollIndicatorVisibility: ScrollIndicatorVisibility = .hidden,
        ignoreSafeArea: Bool = true,
        @ViewBuilder header: @escaping () -> Header,
        @ViewBuilder main: @escaping () -> Main
    ) {
        self.header = header
        self.main = main
        self.spacing = spacing
        self.backgroundColor = backgroundColor
        self.scrollIndicatorVisibility = scrollIndicatorVisibility
        self.ignoreSafeArea = ignoreSafeArea
    }

    var body: some View {
        ScrollView {
            VStack(spacing: spacing) {
                header()
                main()
            }
            .background(backgroundColor)
        }
        .navigationBarBackButtonHidden(true)
        .toolbarBackground(Color.clear, for: .navigationBar)
        .toolbarBackground(.hidden, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                BackButton()
            }
            ToolbarItem(placement: .principal) {
                EmptyView()
            }
        }
        .scrollIndicators(scrollIndicatorVisibility)
        .ignoresSafeArea(edges: ignoreSafeArea ? .top : [])
        .enableInjection()
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
