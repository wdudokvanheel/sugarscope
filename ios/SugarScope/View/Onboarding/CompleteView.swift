import SwiftUI

struct CompleteView: View {
    @EnvironmentObject private var prefs: PreferenceService
    @EnvironmentObject private var model: OnboardModel

    var body: some View {
        VStack {
            Text("Complete!")
            Spacer()

            Button(action: model.completeWizard) {
                Text("Start")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(prefs.theme.accentColor)
        }
        .padding(32)
    }
}
