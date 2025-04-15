import SwiftUI

struct ConnectionConfigurationEditor: View {
    @State private var selectedType: DataSourceType
    @State private var configuration: DataSourceConfiguration?

    var onSave: (DataSourceConfiguration) -> Void

    init(
        configuration: DataSourceConfiguration?,
        _ onSave: @escaping (DataSourceConfiguration) -> Void
    ) {
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
            List {
                Section("Server Settings") {
                    Picker("Data Source Type", selection: $selectedType) {
                        Text("SugarScope").tag(DataSourceType.sugarscope)
                        Text("Nightscout").tag(DataSourceType.nightscout)
                    }
                    .pickerStyle(.segmented)
                    .onChange(of: selectedType) { newType in
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

                    switch selectedType {
                    case .sugarscope:
                        SugarScopeConfigurationView(configuration: $configuration)
                    case .nightscout:
                        NightscoutConfigurationView(configuration: $configuration)
                    }
                    
                    Button("Save connection settings") {
                        if let config = configuration {
                            onSave(config)
                        }
                    }
                    .disabled(configuration == nil)
                }
            }
        }
    }
}
