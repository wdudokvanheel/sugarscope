import SwiftUI

struct ThemeSettingsView: View {
    @EnvironmentObject var preferenceService: PreferenceService
    
    var body: some View {
        Form {
            Section(header: Text("Theme Settings")) {
                
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
        }
        .navigationTitle("Theme")
    }
}
