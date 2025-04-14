import SwiftUI

struct ThemeSettingsView: View {
    @EnvironmentObject var preferenceService: PreferenceService
    
    var body: some View {
        Form {
            Section(header: Text("Main colors")) {
                
                ColorPicker("Background", selection: Binding<Color>(
                    get: { Color(hex: preferenceService.theme.background) },
                    set: { newColor in
                        var updatedTheme = preferenceService.theme
                        updatedTheme.background = newColor.toHex()
                        preferenceService.theme = updatedTheme
                    }
                ))
                
                ColorPicker("Low", selection: Binding<Color>(
                    get: { Color(hex: preferenceService.theme.low) },
                    set: { newColor in
                        var updatedTheme = preferenceService.theme
                        updatedTheme.low = newColor.toHex()
                        preferenceService.theme = updatedTheme
                    }
                ))
                
                ColorPicker("In Range", selection: Binding<Color>(
                    get: { Color(hex: preferenceService.theme.inRange) },
                    set: { newColor in
                        var updatedTheme = preferenceService.theme
                        updatedTheme.inRange = newColor.toHex()
                        preferenceService.theme = updatedTheme
                    }
                ))
                
                ColorPicker("High", selection: Binding<Color>(
                    get: { Color(hex: preferenceService.theme.high) },
                    set: { newColor in
                        var updatedTheme = preferenceService.theme
                        updatedTheme.high = newColor.toHex()
                        preferenceService.theme = updatedTheme
                    }
                ))
                
                ColorPicker("Upper", selection: Binding<Color>(
                    get: { Color(hex: preferenceService.theme.upper) },
                    set: { newColor in
                        var updatedTheme = preferenceService.theme
                        updatedTheme.upper = newColor.toHex()
                        preferenceService.theme = updatedTheme
                    }
                ))
            }
            
            Section(header: Text("Graph")) {
                ColorPicker("Grid X-axis/Time", selection: Binding<Color>(
                    get: { Color(hex: preferenceService.theme.gridLinesX) },
                    set: { newColor in
                        var updatedTheme = preferenceService.theme
                        updatedTheme.gridLinesX = newColor.toHex()
                        preferenceService.theme = updatedTheme
                    }
                ))
                
                ColorPicker("Grid Y-axis/Value", selection: Binding<Color>(
                    get: { Color(hex: preferenceService.theme.gridLinesY) },
                    set: { newColor in
                        var updatedTheme = preferenceService.theme
                        updatedTheme.gridLinesY = newColor.toHex()
                        preferenceService.theme = updatedTheme
                    }
                ))
                
                ColorPicker("Label X-Axis/Time", selection: Binding<Color>(
                    get: { Color(hex: preferenceService.theme.labelAxisX) },
                    set: { newColor in
                        var updatedTheme = preferenceService.theme
                        updatedTheme.labelAxisX = newColor.toHex()
                        preferenceService.theme = updatedTheme
                    }
                ))
                
                ColorPicker("Label Y-Axis/Value", selection: Binding<Color>(
                    get: { Color(hex: preferenceService.theme.labelAxisY) },
                    set: { newColor in
                        var updatedTheme = preferenceService.theme
                        updatedTheme.labelAxisY = newColor.toHex()
                        preferenceService.theme = updatedTheme
                    }
                ))
            }
        }
        .navigationTitle("Theme")
    }
}
