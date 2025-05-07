import SwiftUI

struct ConnectionUrlView: View {
    @EnvironmentObject private var prefs: PreferenceService
    @EnvironmentObject private var model: OnboardModel

    var body: some View {
        VStack {
            Text("Enter url & API Key")
            Spacer()
            TextField("", text: $model.url, prompt: Text("Server URL").foregroundColor(prefs.theme.textColor.opacity(0.5)))
                .padding(3)
                .background(
                    prefs.theme.backgroundColor.cornerRadius(4)
                )
                .foregroundStyle(prefs.theme.textColor)
            SecureField("", text: $model.apiToken, prompt: Text("API Token (optional)").foregroundColor(prefs.theme.textColor.opacity(0.5)))
                .padding(3)
                .background(
                    prefs.theme.backgroundColor.cornerRadius(4)
                )
                .foregroundStyle(prefs.theme.textColor)
            NavigationLink(destination: ConnectionTestView()) {
                Text("Next")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(prefs.theme.accentColor)
        }
        .padding(32)
    }
}
