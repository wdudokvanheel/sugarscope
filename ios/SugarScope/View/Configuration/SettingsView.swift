import SwiftUI

struct SettingsView: View {
    @ObservedObject var dataService: DataSourceService
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        let configuration = dataService.configuration

        VStack {
            TabView {
                GlucoseValuesSettingsView()
                    .tabItem {
                        Label("Glucose values", systemImage: "drop.fill")
                    }
                
                ThemeSettingsView()
                    .tabItem {
                        Label("Theme", systemImage: "paintpalette.fill")
                    }

                VStack {
                    ConnectionConfigurationEditor(configuration: configuration) { conf in
                        self.dataService.saveConfiguration(conf)
                        dismiss()
                    }
                    Spacer()
                }
                .tabItem {
                    Label("Connection", systemImage: "network")
                }
            }
        }
        .navigationTitle("Settings")
    }
}
