import Foundation
import SwiftUI

enum PrefKey: String {
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
    let low: String
    let inRange: String
    let high: String
    let upper: String
}

let defaultTheme = Theme(
    background: Color.black.toHex(),
    low: Color.red.toHex(),
    inRange: Color.green.toHex(),
    high: Color.yellow.toHex(),
    upper: Color.red.toHex()
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

    @Preference(key: .bgLow, defaultValue: 10.0)
    var bgUpper: Double

    init() {}
}
