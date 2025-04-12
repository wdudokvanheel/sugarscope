import SwiftUI

@main
struct SugarScopeApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView{
                MainView()
            }
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
}
