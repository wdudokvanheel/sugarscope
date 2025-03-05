import SwiftUI

@main
struct SugarScopeApp: App {
    var body: some Scene {
        WindowGroup {
           MainView()
                .environmentObject(OrientationInfo())
        }
    }
}
