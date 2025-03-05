import SwiftUI

struct MainView: View {
    @ObservedObject private var dataService: DataSourceService
    @ObservedObject private var realTimeDataSource: RealtimeDataService

    @EnvironmentObject private var orientation: OrientationInfo

    init() {
        let datasource = DataSourceService()
        dataService = datasource
        realTimeDataSource = .init(dataSourceService: datasource)
    }

    var body: some View {
        ZStack(alignment: .top) {
            Color("Background")
                .ignoresSafeArea()

            if dataService.datasource != nil {
                if orientation.orientation == .portrait {
                    GeometryReader { geom in
                        VStack(spacing: 24) {
                            CurrentValueView(realTimeDataSource)
                                .frame(maxWidth: .infinity, maxHeight: geom.size.height * 0.3 - 12)
                            GraphView(realTimeDataSource)
                                .frame(maxWidth: .infinity, maxHeight: geom.size.height * 0.7 - 12)
                        }
                        .padding(12)
                    }
                }
                else {
                    GraphView(realTimeDataSource)
                }
            }
            else {
                ConfigurationWizard { conf in
                    self.dataService.saveConfiguration(conf)
                }
            }
        }
    }
}
