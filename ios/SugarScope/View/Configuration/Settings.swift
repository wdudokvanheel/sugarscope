import SwiftUI

struct SettingsView: View {
    @ObservedObject var dataService: DataSourceService

    var body: some View {
        VStack{
            let configuration = dataService.configuration
            
            ConfigurationWizard(configuration: configuration){ conf in
                self.dataService.saveConfiguration(conf)
            }
            Spacer()
        }
        .navigationTitle("Settings")
    }
}
