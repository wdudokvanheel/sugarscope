import SwiftUI

struct ConnectionTypeView: View {
    @EnvironmentObject private var prefs: PreferenceService
    @EnvironmentObject private var model: OnboardModel

    var body: some View {
        ThemedScreen {
            VStack {
                Spacer()
                Picker("Server type", selection: $model.connectionType) {
                    Text("SugarScope").tag(DataSourceType.sugarscope)
                    Text("Nightscout").tag(DataSourceType.nightscout)
                }
                .onAppear {
                    UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(prefs.theme.accentColor)
                    UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(prefs.theme.indicatorLabelColor)], for: .selected)
                    UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(prefs.theme.textColor)], for: .normal)
                    UISegmentedControl.appearance().backgroundColor = UIColor(prefs.theme.surfaceColor)
                }
                .pickerStyle(.segmented)
                Spacer()
                NavigationLink(destination: ConnectionUrlView()) {
                    Text("Next")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(prefs.theme.accentColor)
            }
            .foregroundStyle(prefs.theme.textColor)
            .padding(32)
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(SugarScopeApp.APP_NAME)
                    .font(.title)
                    .foregroundStyle(prefs.theme.textColor)
            }
        }
    }
}
