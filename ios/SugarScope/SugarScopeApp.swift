import SwiftUI

@main
struct SugarScopeApp: App {
    private let preferences: PreferenceService
    private let dataService: DataSourceService
    private let realTimeDataSource: RealtimeDataService

    init() {
        self.preferences = PreferenceService()
        self.dataService = DataSourceService(prefences: preferences)
        self.realTimeDataSource = RealtimeDataService(dataSourceService: dataService)
    }

    var body: some Scene {
        WindowGroup {
//            VStack {
//                SettingsView()
//
//            }
            NavigationView {
                MainView()
                    .accentColor(preferences.theme.accentColor)
            }
            .environmentObject(preferences)
            .environmentObject(dataService)
            .environmentObject(realTimeDataSource)
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
}
