import Foundation
import os
import SwiftUI

protocol DataSource {
    func getLatestEntries(hours: Int, window: Int) async throws -> [GlucoseMeasurement]
}

enum DataSourceType: String, Codable {
    case sugarscope
    case nightscout
}

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
}
