import SwiftUI

struct NightscoutConfigurationView: View {
    @Binding var configuration: DataSourceConfiguration?

    @State private var url: String = ""
    @State private var apiToken: String = ""

    init(configuration: Binding<DataSourceConfiguration?>) {
        _configuration = configuration

        if let nightscoutConfig = configuration.wrappedValue as? NightscoutDataSourceConfiguration {
            _url = State(initialValue: nightscoutConfig.url)
            _apiToken = State(initialValue: nightscoutConfig.apiToken ?? "")
        }
    }

    var body: some View {
        VStack {
            Text("Nightscout Configuration")
                .font(.headline)

            TextField("Enter URL", text: $url)
                .textFieldStyle(.roundedBorder)
                .padding()
                .onChange(of: url) { _ in
                    updateConfiguration()
                }

            SecureField("Enter API Token (optional)", text: $apiToken)
                .textFieldStyle(.roundedBorder)
                .padding()
                .onChange(of: apiToken) { _ in
                    updateConfiguration()
                }
        }
    }

    private func updateConfiguration() {
        configuration = url.isEmpty
        ? nil
        : NightscoutDataSourceConfiguration(
            url: url,
            apiToken: apiToken.isEmpty ? nil : apiToken
        )
    }
}
