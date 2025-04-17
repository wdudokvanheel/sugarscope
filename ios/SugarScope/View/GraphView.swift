import Foundation
import os
import SwiftUI

struct GraphView: View {
    @EnvironmentObject var prefs: PreferenceService
    @ObservedObject var realTimeDataService: RealtimeDataService

    @State private var showOverlay = false
    @State private var hideOverlayWorkItem: DispatchWorkItem? = nil

    init(_ datasource: RealtimeDataService) {
        self.realTimeDataService = datasource
    }

    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 4) {
                if !realTimeDataService.measurements.isEmpty {
                    ColoredLineGraph(data: realTimeDataService.measurements)
                        .ignoresSafeArea(.all, edges: .leading)
                        .padding(.horizontal, 0)

                } else {
                    VStack(spacing: 16) {
                        Image(systemName: "hourglass")
                            .font(.system(size: 72))

                        Text("Loading graph data")
                            .fontWeight(.thin)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in
                        if !showOverlay {
                            showOverlay = true
                        }
                        resetHideTimer()
                    }
            )

            if showOverlay {
                GraphOverlayMenu(range: GraphRange(hours: self.realTimeDataService.hours, window: self.realTimeDataService.window)) { range in
                    self.realTimeDataService.hours = range.hours
                    self.realTimeDataService.window = range.window
                    self.realTimeDataService.refresh()

                    resetHideTimer()
                }
                .transition(.opacity)
            }
        }
        .padding(0)
        .padding(.bottom, 4)
        .contentShape(Rectangle())
    }

    private func resetHideTimer() {
        hideOverlayWorkItem?.cancel()
        let workItem = DispatchWorkItem {
            withAnimation {
                showOverlay = false
            }
        }
        hideOverlayWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: workItem)
    }
}
