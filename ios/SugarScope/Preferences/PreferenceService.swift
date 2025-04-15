import Foundation
import SwiftUI

enum PreferenceKey: String {
    case connection
    case graph
    case theme
    case bgLow
    case bgHigh
    case bgUpper
}

struct Graph: Encodable, Decodable, Equatable {
    let boundsLower: Double
    let boundsHigher: Double
}

struct Theme: Encodable, Decodable, Equatable {
    var background: String
    var low: String
    var inRange: String
    var high: String
    var upper: String
    var indicatorLabel: String
    var indicatorIcon: String
    var gridLinesX: String
    var gridLinesY: String
    var labelAxisX: String
    var labelAxisY: String
}

let defaultTheme = Theme(
    background: Color.black.toHex(),
    low: Color.red.toHex(),
    inRange: Color.green.toHex(),
    high: Color.yellow.toHex(),
    upper: Color.red.toHex(),
    indicatorLabel: Color.black.toHex(),
    indicatorIcon: Color.black.toHex(),
    gridLinesX: Color.gray.opacity(0.5).toHex(),
    gridLinesY: Color.gray.opacity(0.5).toHex(),
    labelAxisX: Color.gray.toHex(),
    labelAxisY: Color.gray.toHex()
)

let defaultGraph = Graph(boundsLower: 2.5, boundsHigher: 20.0)

class PreferenceService: ObservableObject {
    @Preference(key: .connection, defaultValue: nil)
    var connection: String?

    @Preference(key: .graph, defaultValue: defaultGraph)
    var graph: Graph

    @Preference(key: .theme, defaultValue: defaultTheme)
    var theme: Theme

    @Preference(key: .bgLow, defaultValue: 4.0)
    var bgLow: Double

    @Preference(key: .bgHigh, defaultValue: 7.0)
    var bgHigh: Double

    @Preference(key: .bgUpper, defaultValue: 10.0)
    var bgUpper: Double
}

extension Theme {
    var backgroundColor: Color {
        Color(hex: background)
    }

    var lowColor: Color {
        Color(hex: low)
    }

    var inRangeColor: Color {
        Color(hex: inRange)
    }

    var highColor: Color {
        Color(hex: high)
    }

    var upperColor: Color {
        Color(hex: upper)
    }

    var indicatorLabelColor: Color {
        Color(hex: indicatorLabel)
    }

    var indicatorIconColor: Color {
        Color(hex: indicatorIcon)
    }

    var gridLinesXColor: Color {
        Color(hex: gridLinesX)
    }

    var gridLinesYColor: Color {
        Color(hex: gridLinesY)
    }

    var labelAxisXColor: Color {
        Color(hex: labelAxisX)
    }

    var labelAxisYColor: Color {
        Color(hex: labelAxisY)
    }
}
