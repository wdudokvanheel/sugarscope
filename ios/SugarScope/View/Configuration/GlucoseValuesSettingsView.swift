import SwiftUI

struct GlucoseValuesSettingsView: View {
    @EnvironmentObject var preferenceService: PreferenceService
        
    var body: some View {
        Form {
            Section(header: Text("Blood Glucose Settings")) {
                HStack {
                    Text("Range low")
                    Spacer()
                    TextField("Low bound",
                              value: $preferenceService.bgLow,
                              format: .number)
                        .keyboardType(.decimalPad)
                }
                    
                HStack {
                    Text("Range high")
                    Spacer()
                    TextField("High bound",
                              value: $preferenceService.bgHigh,
                              format: .number)
                        .keyboardType(.decimalPad)
                }
                    
                HStack {
                    Text("Range upper")
                    Spacer()
                    TextField("Upper bound",
                              value: $preferenceService.bgUpper,
                              format: .number)
                        .keyboardType(.decimalPad)
                }
            }
        }
    }
}
