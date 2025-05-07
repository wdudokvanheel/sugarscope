import SwiftUI

struct IntroView: View {
    @EnvironmentObject private var prefs: PreferenceService

    var body: some View {
        VStack {
            Text("Intro view")
            Spacer()
            NavigationLink(destination: FeatureView()) {
                Text("Next")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(prefs.theme.accentColor)

        }
        .padding(32)
    }
}
