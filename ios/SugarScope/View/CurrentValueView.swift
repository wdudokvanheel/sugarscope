import Foundation
import os
import SwiftUI

struct CurrentValueView: View {
    @ObservedObject private var realTimeDataService: RealtimeDataService
    @State private var animatedBackgroundColor: Color = .gray

    init(_ realTimeDataService: RealtimeDataService) {
        self.realTimeDataService = realTimeDataService
    }

    var backgroundColor: Color {
        if let value = realTimeDataService.currentValue {
            return value < 4 || value > 7 ? Color.red : Color.green
        }
        return Color.gray
    }

    var body: some View {
        VStack {
            VStack {}
                .frame(maxWidth: .infinity, maxHeight: 5)

            ZStack {
                VStack {
                    if let value = realTimeDataService.currentValue {
                        Text(String(format: "%.1f", value))
                            .font(.system(size: 72))
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.black)
                    }
                    else {
                        Text("???")
                            .font(.system(size: 48))
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.black)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(animatedBackgroundColor)
                        .animation(.easeInOut(duration: 0.5), value: animatedBackgroundColor)
                )
                if let lastUpdate = realTimeDataService.lastUpdate {
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()

                            Text("Last updated \(lastUpdate.formatted(date: .omitted, time: .complete))")
                                .font(.caption)
                                .foregroundStyle(Color.black.opacity(0.6))
                                .padding(.vertical, 6)
                                .padding(.horizontal, 8)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .onChange(of: realTimeDataService.currentValue) { _ in
            withAnimation {
                animatedBackgroundColor = self.backgroundColor
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
