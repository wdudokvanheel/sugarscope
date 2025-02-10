import Foundation
import os
import SwiftUI

struct MainView: View {
    let datasource: NightscoutDataSource = .init()

    var body: some View {
        GraphView(datasource)
    }
}
