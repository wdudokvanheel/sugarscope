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
        TextField("Server URL", text: $url)
            .textFieldStyle(.roundedBorder)
            .onChange(of: url) { _ in
                updateConfiguration()
            }

        SecureField("API Token (optional)", text: $apiToken)
            .textFieldStyle(.roundedBorder)
            .onChange(of: apiToken) { _ in
                updateConfiguration()
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
