import Foundation
import os

class NightscoutDataSource : DataSource{
    private let logger = Logger.new("datasource.nightscout")
    
    private let base_url = "https://night.wdudokvanheel.nl"
    private let apiToken = "wesley-00f19b06388cfaa3"

    func getLast12h() async throws -> [GlucoseMeasurement] {
        let twelveHoursAgo = Date().addingTimeInterval(-12 * 60 * 60)
        let timestamp = Int(twelveHoursAgo.timeIntervalSince1970 * 1000) // Convert to ms

        let url = "\(base_url)/api/v1/entries.json?token=\(apiToken)"

        guard var urlComponents = URLComponents(string: url) else {
            logger.error("Invalid URL")
            throw NetworkError.invalidURL
        }

        urlComponents.queryItems = [
            URLQueryItem(name: "find[date][$gte]", value: "\(timestamp)"),
            URLQueryItem(name: "count", value: "1000"), // Fetch more data
            URLQueryItem(name: "interval", value: "5") // Group into 5-minute averages
        ]

        guard let url = urlComponents.url else {
            logger.error("Failed to construct valid Nightscout URL")
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            logger.error("Invalid response from Nightscout server")
            throw NetworkError.invalidResponse
        }

        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let nightscoutEntries = try decoder.decode([NightscoutEntryDTO].self, from: data)

            return groupEntriesIntoIntervals(entries: nightscoutEntries)
        } catch {
            logger.error("Decoding error: \(error.localizedDescription)")
            throw error
        }
    }

    private func groupEntriesIntoIntervals(entries: [NightscoutEntryDTO]) -> [GlucoseMeasurement] {
        let fiveMinuteInterval: TimeInterval = 5 * 60 * 1000

        let groupedEntries = Dictionary(grouping: entries) { (entry: NightscoutEntryDTO) -> Int in
            Int(entry.date / fiveMinuteInterval)
        }

        let aggregatedMeasurements: [GlucoseMeasurement] = groupedEntries.values.map { group in
            let totalSGV = group.reduce(0.0) { $0 + $1.sgv }
            let avgSGV = totalSGV / Double(group.count)

            let totalDate = group.reduce(0.0) { $0 + $1.date }
            let avgDate = totalDate / Double(group.count)

            return GlucoseMeasurement(time: avgDate / 1000, value: avgSGV.toMmol())
        }

        return aggregatedMeasurements.sorted { $0.time < $1.time }
    }
}

struct NightscoutEntryDTO: Decodable {
    let sgv: Double // Sensor glucose value
    let date: TimeInterval // Epoch time in milliseconds

    func toGlucoseMeasurement() -> GlucoseMeasurement {
        return GlucoseMeasurement(time: date / 1000, value: sgv.toMmol())
    }
}
