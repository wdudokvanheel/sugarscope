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
        VStack {
            Text("SugarScope Configuration")
                .font(.headline)

            TextField("Enter URL", text: $url)
                .textFieldStyle(.roundedBorder)
                .padding()
                .onChange(of: url) { newValue in
                    configuration = newValue.isEmpty
                    ? nil
                    : SugarScopeDataSourceConfiguration(url: newValue)
                }
        }
    }
}
