import Foundation
import os
import SwiftUI

struct GraphView: View {
    @ObservedObject var realTimeDataService: RealtimeDataService

    init(_ datasource: RealtimeDataService) {
        self.realTimeDataService = datasource
    }

    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 4) {
                if !realTimeDataService.measurements.isEmpty {
                    ColoredLineGraph(data: realTimeDataService.measurements)
                        .ignoresSafeArea(.all, edges: .leading)

                } else {
                    Text("Loading data...")
                }
            }
        }
        .padding(0)
    }
}
