import SwiftUI

struct SugarScopeConfigurationView: View {
    @Binding var configuration: DataSourceConfiguration?

    @State private var url: String = ""

    init(configuration: Binding<DataSourceConfiguration?>) {
        _configuration = configuration

        if let sugarScopeConfig = configuration.wrappedValue as? SugarScopeDataSourceConfiguration {
            _url = State(initialValue: sugarScopeConfig.url)
        }
    }

    var body: some View {
        TextField("Server URL", text: $url)
            .textFieldStyle(.roundedBorder)
            .onChange(of: url) { newValue in
                configuration = newValue.isEmpty
                    ? nil
                    : SugarScopeDataSourceConfiguration(url: newValue)
            }
    }
}
