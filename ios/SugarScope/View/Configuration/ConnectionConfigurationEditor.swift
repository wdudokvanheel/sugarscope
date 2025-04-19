import SwiftUI

struct ConnectionConfigurationEditor: View {
    @EnvironmentObject private var prefs: PreferenceService
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
        ThemedSection {
            VStack {
                Text("Server type")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(prefs.theme.textColor)
                
                Picker("Server type", selection: $selectedType) {
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
                
                ThemedDivider()
                
                switch selectedType {
                case .sugarscope:
                    SugarScopeConfigurationView(configuration: $configuration)
                case .nightscout:
                    NightscoutConfigurationView(configuration: $configuration)
                }
                
                ThemedDivider()
                
                Button("Save connection settings") {
                    if let config = configuration {
                        onSave(config)
                    }
                }
                
                .disabled(configuration == nil)
            }
            .padding(8)
        }
        .padding(8)
    }
}
