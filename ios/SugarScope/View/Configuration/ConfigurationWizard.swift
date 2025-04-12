import SwiftUI

struct ConfigurationWizard: View {
    @State private var selectedType: DataSourceType = .sugarscope
    @State private var configuration: DataSourceConfiguration?

    var onSave: (DataSourceConfiguration) -> Void
    
    init(configuration: DataSourceConfiguration?, _ onSave: @escaping (DataSourceConfiguration) -> Void){
        self._selectedType = State(initialValue: .sugarscope)
        self._configuration = State(initialValue: configuration)
        print("Starting with configuration: \(configuration)")
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
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            // Dynamically switch between configuration views
            switch selectedType {
            case .sugarscope:
                SugarScopeConfigurationView(configuration: $configuration)
            case .nightscout:
                NightscoutConfigurationView(configuration: $configuration)
            }

            // Save button (only enabled when valid configuration exists)
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
