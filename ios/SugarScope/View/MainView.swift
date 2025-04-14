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
                                    CurrentValueView(realTimeDataSource)
                                        .frame(maxWidth: .infinity, maxHeight: geom.size.height * 0.3 - 12)
                                    NavigationLink(destination: SettingsView(dataService: dataService)) {
                                        Image(systemName: "gear")
                                            .foregroundStyle(.black)
                                            .padding(.top, 12 + 8)
                                            .padding(.trailing, 8)
                                    }
                                }
                                GraphView(realTimeDataSource)
                                    .frame(maxWidth: .infinity, maxHeight: geom.size.height * 0.7 - 12)
                            }
                            .padding(12)
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
