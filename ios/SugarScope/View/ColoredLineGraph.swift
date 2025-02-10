import Charts
import SwiftUI

struct ColoredLineGraph: View {
    @Environment(\.verticalSizeClass) private var verticalSizeClass

    let bounds_low: Double
    let bounds_high: Double
    let color_range_low: Double
    let color_range_high: Double
    let color_range_upper_high: Double

    var data: [GlucoseMeasurement]

    init(data: [GlucoseMeasurement]) {
        self.data = data
        self.bounds_low = 2.5
        self.bounds_high = 20
        self.color_range_low = 4
        self.color_range_high = 7
        self.color_range_upper_high = 10
    }

    init(data: [GlucoseMeasurement], bounds_low: Double, bounds_high: Double, color_range_low: Double, color_range_high: Double, color_range_upper_high: Double) {
        self.data = data
        self.bounds_low = bounds_low
        self.bounds_high = bounds_high
        self.color_range_low = color_range_low
        self.color_range_high = color_range_high
        self.color_range_upper_high = color_range_upper_high

    }

    var minValue: Double {
        max(bounds_low, data.map { $0.value }.min() ?? bounds_low)
    }

    var maxValue: Double {
        min(bounds_high, data.map { $0.value }.max() ?? bounds_high)
    }

    // Using a logarithmic scale for normalization to calculate the stops for the line gradient.
    var gradient_range_low: Double {
        (log(color_range_low) - log(minValue)) / (log(maxValue) - log(minValue))
    }

    var gradient_range_high: Double {
        (log(color_range_high) - log(minValue)) / (log(maxValue) - log(minValue))
    }

    var gradient_range_upper: Double {
        (log(color_range_upper_high) - log(minValue)) / (log(maxValue) - log(minValue))
    }

    var timeRange: [Date] {
        guard let firstDate = data.map({ $0.date }).min(),
              let lastDate = data.map({ $0.date }).max()
        else {
            return []
        }
        let calendar = Calendar.current
        var times: [Date] = []
        var current = calendar.startOfHour(for: firstDate)
        while current <= lastDate {
            times.append(current)
            current = calendar.date(byAdding: .hour, value: 1, to: current)!
        }
        return times.dropFirst().map { $0 }
    }

    var body: some View {
        GeometryReader { geometry in
            Chart(data) { point in
                AreaMark(
                    x: .value("Time", point.date),
                    yStart: .value("Value", bounds_low),
                    yEnd: .value("Value", point.value)
                )
                .foregroundStyle(.gray.opacity(0.1))

                LineMark(
                    x: .value("Time", point.date),
                    y: .value("Value", point.value)
                )
                .foregroundStyle(
                    LinearGradient(
                        gradient: Gradient(stops: [
                            .init(color: .red, location: 0.0),
                            .init(color: .red, location: gradient_range_low - 0.035),

                            .init(color: .green, location: gradient_range_low + 0.025),
                            .init(color: .green, location: gradient_range_high - 0.025),

                            .init(color: .yellow, location: gradient_range_high + 0.025),
                            .init(color: .red, location: gradient_range_upper),

                            .init(color: .red, location: gradient_range_upper),
                            .init(color: .red, location: 1.0)
                        ]),
                        startPoint: .bottom,
                        endPoint: .top
                    )
                )
                .interpolationMethod(.catmullRom)
                .lineStyle(StrokeStyle(lineWidth: 3))
            }
            .chartXScale(domain: Date(timeIntervalSince1970: data.first?.time ?? 0) ...
                Date(timeIntervalSince1970: data.last?.time ?? 0))

            .chartXAxis {
                AxisMarks(values: timeRange) { value in
                    if value.index % 2 == 0 || verticalSizeClass == .compact {
                        AxisGridLine()
                        AxisTick()
                        AxisValueLabel(format: .dateTime.hour(.defaultDigits(amPM: .omitted)))
                    }
                }
            }
            .chartYAxis {
                AxisMarks(values: [3, color_range_low, 5, 6, color_range_high, color_range_upper_high, 15, 20]) { _ in
                    //                    AxisGridLine(stroke: StrokeStyle(lineWidth: value.as(Double.self) == color_range_low || value.as(Double.self) == color_range_high ? 2 : 1))
                    AxisGridLine()
                    AxisTick()
                    AxisValueLabel()
                }
            }
            .chartYScale(domain: bounds_low ... bounds_high, type: .log)
            .padding(.top, 8)
            .frame(height: verticalSizeClass == .compact ? geometry.size.height : geometry.size.height )
            .frame(maxWidth: .infinity)
        }
    }
}
