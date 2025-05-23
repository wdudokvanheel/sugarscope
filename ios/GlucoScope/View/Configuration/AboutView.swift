import SwiftUI

struct AboutView: View {
    @EnvironmentObject private var prefs: PreferenceService
    @EnvironmentObject private var dataService: DataSourceService

    @State private var showingEraseAlert = false

    var sourceCodeUrl: String {
        GlucoScopeApp.URL_SOURCE + "tree/ios-v" + UIApplication.appVersion
    }

    private func eraseAllData() {
        if let bundleID = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundleID)
            UserDefaults.standard.synchronize()
        }
        dataService.clearConfiguration()
    }

    var body: some View {
        VStack {
            ThemedLogoGraphic()
                .padding(.top, 16)
                .padding(.horizontal, 16)

            Spacer()

            ThemedSection {
                VStack(alignment: .leading, spacing: 16) {
                    // App name & version
                    VStack(alignment: .leading, spacing: 0) {
                        Text(GlucoScopeApp.APP_NAME)
                            .font(.title)
                            .fontWeight(.semibold)
                        Text("iOS client v\(UIApplication.appVersion) build \(UIApplication.appBuild)")
                            .font(.footnote)
                            .fontWeight(.light)
                            .opacity(0.9)
                    }

                    // Links
                    VStack(alignment: .leading) {
                        Link("Source code", destination: URL(string: sourceCodeUrl)!)
                        Link("License", destination: URL(string: GlucoScopeApp.URL_LICENSE)!)
                        Link("Privacy Policy", destination: URL(string: GlucoScopeApp.URL_PRIVACY)!)
                    }

                    // Erase button
                    VStack(alignment: .center) {
                        Button("Erase all data") {
                            showingEraseAlert = true
                        }
                        .font(.caption)
                        .opacity(0.75)
                        .alert("Are you sure you want to erase all data?", isPresented: $showingEraseAlert) {
                            Button("Erase", role: .destructive) {
                                eraseAllData()
                            }
                            Button("Cancel", role: .cancel) {}
                        } message: {
                            Text("This action cannot be undone.")
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundStyle(prefs.theme.textColor)
                .padding(16)
            }
            .padding(.bottom, 16)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("About")
                        .minimumScaleFactor(0.5)
                        .font(.title)
                        .foregroundStyle(prefs.theme.textColor)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
