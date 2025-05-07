import SwiftUI

struct ConnectionTypeView: View {
    @EnvironmentObject private var prefs: PreferenceService
    @EnvironmentObject private var model: OnboardModel

    var body: some View {
        VStack {
            Text("nightscout or sugarscope")
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
        .padding(32)
    }
}
