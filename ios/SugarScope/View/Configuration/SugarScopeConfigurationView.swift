import SwiftUI

struct SugarScopeConfigurationView: View {
    @Binding var configuration: DataSourceConfiguration?

    @State private var url: String = ""

    var body: some View {
        VStack {
            Text("SugarScope Configuration")
                .font(.headline)

            TextField("Enter URL", text: $url)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .onChange(of: url) { newValue in
                    configuration = newValue.isEmpty ? nil : SugarScopeDataSourceConfiguration(url: newValue)
                }
        }
    }
}
