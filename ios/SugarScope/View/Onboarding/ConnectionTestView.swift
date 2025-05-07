import SwiftUI

struct ConnectionTestView: View {
    @EnvironmentObject private var prefs: PreferenceService
    @EnvironmentObject private var model: OnboardModel

    var body: some View {
        VStack {
            Text("Test connection")
            Spacer()
            Text("type: \(model.connectionType.rawValue)")
            Text("url: \(model.url)")
            Text("api: \(model.apiToken)")

            Spacer()

            if let state = model.connectionTestState {
                switch state {
                    case .pending: Text("Testing...")
                    case .failed(let error): Text("Error: \(error)")
                    case .success: Text("Succes")
                }

                Spacer()
            }

            Button(action: model.testConnection) {
                Text("Test Again")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(prefs.theme.accentColor)
            .disabled(!model.canTest)

            NavigationLink(destination: CompleteView()) {
                Text("Next")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(prefs.theme.accentColor)
            .disabled(!model.testSuccessful)
        }
        .padding(32)
        .onAppear {
            model.testConnection()
        }
    }
}
