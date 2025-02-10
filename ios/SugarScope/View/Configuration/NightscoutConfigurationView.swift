import SwiftUI

struct NightscoutConfigurationView: View {
    @Binding var configuration: DataSourceConfiguration?

    @State private var url: String = ""
    @State private var apiToken: String = ""

    var body: some View {
        VStack {
            Text("Nightscout Configuration")
                .font(.headline)

            TextField("Enter URL", text: $url)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .onChange(of: url) { _ in updateConfiguration() }

            SecureField("Enter API Token (optional)", text: $apiToken)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .onChange(of: apiToken) { _ in updateConfiguration() }
        }
    }

    private func updateConfiguration() {
        configuration = url.isEmpty ? nil : NightscoutDataSourceConfiguration(url: url, apiToken: apiToken.isEmpty ? nil : apiToken)
    }
}
