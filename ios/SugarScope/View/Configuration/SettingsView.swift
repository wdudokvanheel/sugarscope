import Foundation
import os
import SwiftUI

struct SettingsTab: Identifiable, Equatable {
    var id: String
    var label: String
    var icon: String
}

struct SettingsView: View { // <Content: View>: View {
    @EnvironmentObject var prefs: PreferenceService

    @State private var selectedTab: SettingsTab
    private let tabs: [SettingsTab] = [
        SettingsTab(id: "theme", label: "Themes", icon: "paintpalette.fill"),
        SettingsTab(id: "bgvalues", label: "Glucose values", icon: "drop.fill"),
        SettingsTab(id: "connection", label: "Connection", icon: "network")
    ]

    init() {
        self.selectedTab = tabs[0]
    }

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                VStack {
                    switch self.selectedTab.id {
                    case "bgvalues":
                        GlucoseValuesSettingsView()
                    case "theme":
                        ThemeSettingsView()
                    case "connection":
                        ConnectionSettingsView()
                    default:
                        Text("Select a setting below")
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)

                HStack {
                    ForEach(tabs) { tab in
                        VStack {
                            Button(action: {
                                self.selectedTab = tab
                            }, label: {
                                VStack(spacing: 4) {
                                    Image(systemName: tab.icon)
                                        .font(.title2)
                                    Text(tab.label)
                                        .font(.caption)
                                }
                                .foregroundStyle(tab == selectedTab ? prefs.theme.accentColor : prefs.theme.textColor.opacity(0.65))
                            })
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                .frame(height: 50)
                .frame(maxWidth: .infinity)
                .background(prefs.theme.surfaceColor)
            }
        }
        .accentColor(prefs.theme.accentColor)
        .background(prefs.theme.backgroundColor.ignoresSafeArea())
    }
}
