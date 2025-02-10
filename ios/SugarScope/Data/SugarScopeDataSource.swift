import Foundation
import os
import SwiftUI

class SugarScopeDataSource: DataSource {
    private let logger = Logger.new("datasource.sugarscope")

    private let base_url = "http://10.0.0.21:9090"
    
    func getLast12h() async throws -> [GlucoseMeasurement] {
        guard let url = URL(string: "\(base_url)/graph") else {
            logger.error("Invalid URL")
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            logger.error("Invalid response from server")
            throw NetworkError.invalidResponse
        }
        
        if let responseString = String(data: data, encoding: .utf8) {
            logger.trace("Response from \(url)\n\(responseString)")
        } else {
            logger.warning("Unable to decode response data as UTF-8 string")
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let measurements = try decoder.decode([GlucoseMeasurement].self, from: data)
            return measurements
        } catch {
            logger.error("Decoding error: \(error.localizedDescription)")
            throw error
        }
    }
}

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case noData
}
