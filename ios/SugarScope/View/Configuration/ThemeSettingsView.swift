import Foundation
import SwiftUI

let theme = Theme(
    name: "Default",
    url: "",
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

struct ThemeSettingsView: View {
    @EnvironmentObject var prefs: PreferenceService
    @State var themes: [Theme] = []
    @State var previewData: [GlucoseMeasurement] = []

    var body: some View {
        GeometryReader { geom in
            VStack {
                ZStack {
                    prefs.theme.backgroundColor
                    ColoredLineGraph(data: previewData)
                        .padding(8)
                }
                .frame(height: geom.size.height * 0.33)
                .cornerRadius(12)
                .padding(.horizontal, 8)

                List {
                    Section(header: Text("Select theme")) {
                        ForEach(themes) { theme in
                            HStack {
                                if theme == prefs.theme {
                                    Image(systemName: "checkmark")
                                }
                                Text("\(theme.name)")
                            }
                            .onTapGesture {
                                prefs.theme = theme
                            }
                        }
                    }
                }
            }
        }
        .onAppear {
            self.previewData = generatePreviewGlucoseData(minRange: prefs.graph.boundsLower, maxRange: prefs.graph.boundsHigher, low: prefs.bgLow, high: prefs.bgHigh)
            self.themes = loadThemes()
        }
    }

    func loadThemes() -> [Theme] {
        guard let url = Bundle.main.url(forResource: "themes", withExtension: "json") else {
            print("Could not locate themes.json file in the bundle.")
            return []
        }

        do {
            let data = try Data(contentsOf: url)
            let themes = try JSONDecoder().decode([Theme].self, from: data)
            return themes.sorted { $0.name < $1.name }
        } catch {
            print("Error reading or decoding the file: \(error)")
            return []
        }
    }

    private func generatePreviewGlucoseData(
        minRange: Double,
        maxRange: Double,
        low: Double,
        high: Double,
        noiseFraction: Double = 0.05, // max ±5% noise
        includeMealSpikes: Bool = true
    ) -> [GlucoseMeasurement] {
        var data: [GlucoseMeasurement] = []
        let cal = Calendar.current
        let today = Date()
        let startOfDay = cal.startOfDay(for: today)
        guard
            let t0 = cal.date(bySettingHour: 9, minute: 0, second: 0, of: startOfDay),
            let t1 = cal.date(bySettingHour: 15, minute: 0, second: 0, of: startOfDay)
        else { return data }

        let interval = TimeInterval(5 * 60) // 5‑minute sampling
        let totalSeconds = t1.timeIntervalSince(t0) // 6h = 21 600s
        let firstSegSecs = totalSeconds / 3.0 // 2h = 7 200s
        let secondSegSecs = totalSeconds - firstSegSecs // 4h = 14 400s

        // --- climb/fall params (first 2h) ---
        let climbMin = minRange * 1.1
        let climbMax = maxRange * 0.7
        let centerCL = (climbMin + climbMax) / 2
        let ampCL = (climbMax - climbMin) / 2

        // --- sine params (last 4h) ---
        let centerLH = (low + high) / 2
        let ampLH = (high - low) / 2

        // --- noise & spike settings ---
        let fullRange = maxRange - minRange
        let noiseAmp = fullRange * noiseFraction
        let mealSpikeAmp = fullRange * 0.3 // up to ±30% bump
        let mealSpikeWidth = TimeInterval(30 * 60) // 30 min σ
        // offsets from t0: 09:30, 12:00, 13:00
        let mealOffsets: [TimeInterval] = [30 * 60, 180 * 60, 240 * 60]

        var current = t0
        while current <= t1 {
            let dt = current.timeIntervalSince(t0)
            let raw: Double

            if dt < firstSegSecs {
                // smooth climb‑and‑fall: map [0…7 200] → [–π/2…3π/2]
                let angle = -Double.pi / 2 + (dt / firstSegSecs) * 2 * Double.pi
                raw = centerCL + ampCL * sin(angle)

            } else {
                // one sine cycle in [low…high]
                let subDt = dt - firstSegSecs
                let frac = subDt / secondSegSecs
                let angle = frac * 2 * Double.pi
                raw = centerLH + ampLH * sin(angle)
            }

            var value = raw

            // add meal‑spike bumps
            if includeMealSpikes {
                for meal in mealOffsets {
                    let delta = dt - meal
                    // gaussian bump
                    let bump = mealSpikeAmp * exp(-0.5 * (delta / mealSpikeWidth) * (delta / mealSpikeWidth))
                    value += bump
                }
            }

            // add a bit of random noise
            let noise = Double.random(in: -noiseAmp ... noiseAmp)
            value += noise

            // clamp into [minRange…maxRange]
            let clamped = min(max(value, minRange), maxRange)
            data.append(.init(time: current.timeIntervalSince1970, value: clamped))

            current.addTimeInterval(interval)
        }

        return data
    }
}
