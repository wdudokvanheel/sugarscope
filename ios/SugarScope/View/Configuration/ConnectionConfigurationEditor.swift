import SwiftUI

struct ConnectionConfigurationEditor: View {
    @State private var selectedType: DataSourceType
    @State private var configuration: DataSourceConfiguration?

    var onSave: (DataSourceConfiguration) -> Void
    
    init(
        configuration: DataSourceConfiguration?,
        _ onSave: @escaping (DataSourceConfiguration) -> Void
    ) {
        // Determine initial selectedType from configuration
        if let _ = configuration as? NightscoutDataSourceConfiguration {
            _selectedType = State(initialValue: .nightscout)
        } else {
            _selectedType = State(initialValue: .sugarscope)
        }
        
        self._configuration = State(initialValue: configuration)
        self.onSave = onSave
    }

    var body: some View {
        VStack {
            Text("Select Data Source Type")
                .font(.headline)

            Picker("Data Source Type", selection: $selectedType) {
                Text("SugarScope").tag(DataSourceType.sugarscope)
                Text("Nightscout").tag(DataSourceType.nightscout)
            }
            .pickerStyle(.segmented)
            .padding()
            .onChange(of: selectedType) { newType in
                // If user changes type, reset to an empty config of that type if you want
                // or just nil out to start fresh:
                switch newType {
                case .sugarscope:
                    if !(configuration is SugarScopeDataSourceConfiguration) {
                        configuration = SugarScopeDataSourceConfiguration(url: "")
                    }
                case .nightscout:
                    if !(configuration is NightscoutDataSourceConfiguration) {
                        configuration = NightscoutDataSourceConfiguration(url: "", apiToken: nil)
                    }
                }
            }

            // Dynamically switch between configuration views
            switch selectedType {
            case .sugarscope:
                SugarScopeConfigurationView(configuration: $configuration)
            case .nightscout:
                NightscoutConfigurationView(configuration: $configuration)
            }

            Button("Save Configuration") {
                if let config = configuration {
                    onSave(config)
                }
            }
            .buttonStyle(.borderedProminent)
            .disabled(configuration == nil)
            .padding()
        }
    }
}
