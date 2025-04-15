import SwiftUI

struct GraphOverlayMenu: View {
    @EnvironmentObject var prefs: PreferenceService
    let graphRangeSelected: (GraphRange) -> Void
    let range: GraphRange

    init(range: GraphRange, _ graphRangeSelected: @escaping (GraphRange) -> Void) {
        self.range = range
        self.graphRangeSelected = graphRangeSelected
    }

    var body: some View {
        ZStack {
            prefs.theme.backgroundColor.opacity(0.5)
                .ignoresSafeArea(.all)
            OrientationView { orientation in
                VStack(alignment: .trailing) {
                    Spacer()
                    switch orientation {
                    case .portrait:
                        GraphRangeSelector(range, self.graphRangeSelected)
                    case .landscape:
                        HStack {
                            Spacer()
                            GraphRangeSelector(range, self.graphRangeSelected)
                                .fixedSize(horizontal: true, vertical: true)
                            Spacer()
                        }
                    }
                }
                .padding(.horizontal, 8)
            }
            .padding(.horizontal, 8)
        }
    }
}
