import Foundation
import os
import SwiftUI

struct GraphView: View {
    let datasource: DataSource

    @State
    private var glucoseData: [GlucoseMeasurement] = []
    private let timer = Timer.publish(every: 30, on: .main, in: .common).autoconnect()

    private var last_measurement: Double? {
        return glucoseData.last?.value
    }

    init(_ datasource: DataSource) {
        self.datasource = datasource
    }

    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 4) {
                if let last = last_measurement {
                    HStack {
                        Text(String(format: "%.1f", last))
                            .font(.system(size: 48))
                            .fontWeight(.semibold)
                            .foregroundStyle(last < 4.0 || last > 7.0 ? .red : .green)
                    }
                    .padding(.horizontal, 4)
                }
                if !glucoseData.isEmpty {
                    ColoredLineGraph(data: glucoseData)
                        .ignoresSafeArea(.all, edges: .leading)

                } else {
                    Text("Loading data...")
                }
            }
        }
        .padding(0)
        .onReceive(timer) { _ in
            Task {
                await fetchData()
            }
        }
        .task {
            await fetchData()
        }
    }

    private func fetchData() async {
        do {
            glucoseData = try await datasource.getLastEntries(hours: 12, window: 5)
        } catch {
            print("Error fetching data: \(error)")
        }
    }
}
