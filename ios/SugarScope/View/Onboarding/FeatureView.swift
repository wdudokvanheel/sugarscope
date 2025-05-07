import SwiftUI

struct FeatureView: View {
    @EnvironmentObject private var prefs: PreferenceService

    var body: some View {
        VStack {
            Text("Feature view")
            Spacer()
            NavigationLink(destination: ConnectionTypeView()) {
                Text("Next")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(prefs.theme.accentColor)
        }
        .padding(32)
    }
}
