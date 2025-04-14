import Foundation
import os
import SwiftUI

struct CurrentValueView: View {
    @EnvironmentObject private var prefs: PreferenceService
    @ObservedObject private var realTimeDataService: RealtimeDataService
    @State private var animatedBackgroundColor: Color = .gray

    init(_ realTimeDataService: RealtimeDataService) {
        self.realTimeDataService = realTimeDataService
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
        .onAppear {
            if let value = realTimeDataService.currentValue {
                animatedBackgroundColor = color_based_on_value(value)
            }
        }
        .onChange(of: realTimeDataService.currentValue) { newValue in
            withAnimation {
                if let newValue = newValue {
                    animatedBackgroundColor = color_based_on_value(newValue)
                } else {
                    animatedBackgroundColor = .gray
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func color_based_on_value(_ value: Double) -> Color {
        let startColor = Color(hex: prefs.theme.high)
        let endColor = Color(hex: prefs.theme.upper)

        if value < prefs.bgLow {
            return Color(hex: prefs.theme.low)
        }
        if value < prefs.bgHigh {
            return Color(hex: prefs.theme.inRange)
        }
        if value >= prefs.bgUpper {
            return endColor
        }

        let fraction = CGFloat((value - prefs.bgHigh) / (prefs.bgUpper - prefs.bgHigh))
        return Color.interpolate(from: startColor, to: endColor, fraction: fraction)
    }
}
