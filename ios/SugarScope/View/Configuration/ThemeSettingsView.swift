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

    var body: some View {
        VStack {
            List {
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
        .onAppear {
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
            return themes
        } catch {
            print("Error reading or decoding the file: \(error)")
            return []
        }
    }
}
