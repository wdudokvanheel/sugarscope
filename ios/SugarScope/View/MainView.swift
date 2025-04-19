import SwiftUI

struct MainView: View {
    @EnvironmentObject private var prefs: PreferenceService
    @EnvironmentObject private var dataService: DataSourceService
    @EnvironmentObject private var realTimeDataSource: RealtimeDataService

    var body: some View {
        ZStack(alignment: .top) {
            Color(hex: prefs.theme.background)
                .ignoresSafeArea()

            if dataService.datasource != nil {
                OrientationView { orientation in
                    if orientation == .portrait {
                        GeometryReader { geom in
                            VStack(spacing: 24) {
                                ZStack(alignment: .topTrailing) {
                                    IndicatorView(realTimeDataSource)
                                        .frame(maxWidth: .infinity, maxHeight: geom.size.height * 0.3 - 12)
                                    NavigationLink(destination: SettingsView()) {
                                        Image(systemName: "gear")
                                            .foregroundStyle(prefs.theme.indicatorIconColor)
                                            .padding(.top, 8)
                                            .padding(.trailing, 8 + 8)
                                    }
                                    .padding(0)
                                }
                                GraphView(realTimeDataSource)
                                    .frame(maxWidth: .infinity, maxHeight: geom.size.height * 0.7 - 12)
                            }
                            .padding(0)
                        }
                    }
                    else {
                        ZStack {
                            GraphView(realTimeDataSource)
                            if let value = realTimeDataSource.currentValue {
                                VStack {
                                    HStack {
                                        Text(String(format: "%.1f", value))
                                            .font(.title2)
                                            .padding(8)
                                            .foregroundStyle(Color.black)
                                            .background(
                                                RoundedRectangle(cornerRadius: 4)
                                                    .fill(value < 4 || value > 7 ? Color.red : Color.green)
                                            )
                                        Spacer()
                                    }
                                    Spacer()
                                }
                                .padding()
                            }
                        }
                    }
                }
            }
            else {
                ConnectionConfigurationEditor(configuration: nil) { conf in
                    self.dataService.saveConfiguration(conf)
                }
            }
        }
    }
}
