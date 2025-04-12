import SwiftUI

struct SettingsView: View {
    @ObservedObject var dataService: DataSourceService
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack{
            let configuration = dataService.configuration
            
            ConfigurationWizard(configuration: configuration){ conf in
                self.dataService.saveConfiguration(conf)
                dismiss()
            }
            Spacer()
        }
        .navigationTitle("Settings")
    }
}
