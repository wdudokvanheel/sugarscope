import Foundation
import os
import SwiftUI

struct CurrentValueView: View {
    @ObservedObject private var realTimeDataService: RealtimeDataService
    @State private var animatedBackgroundColor: Color = .gray
    
    let color_range_low: Double
    let color_range_high: Double
    let color_range_upper_high: Double

    init(_ realTimeDataService: RealtimeDataService) {
        self.color_range_low = 4
        self.color_range_high = 7
        self.color_range_upper_high = 10
        
        self.realTimeDataService = realTimeDataService
        
        // Make sure your animated background starts off in sync:
        _animatedBackgroundColor = State(initialValue: {
            if let value = realTimeDataService.currentValue {
                return color_based_on_value(value)
            } else {
                return .gray
            }
        }())
    }

    var backgroundColor: Color {
        if let value = realTimeDataService.currentValue {
            return color_based_on_value(value)
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
                    } else {
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
    
    private func color_based_on_value(_ value: Double) -> Color {
        let startColor = Color.yellow
        let endColor = Color.red
        
        if value < color_range_low {
            return .red
        }
        if value < color_range_high {
            return .green
        }
        if value >= color_range_upper_high {
            return endColor
        }
        
        let fraction = CGFloat((value - color_range_high) / (color_range_upper_high - color_range_high))
        return Color.interpolate(from: startColor, to: endColor, fraction: fraction)
    }
}
