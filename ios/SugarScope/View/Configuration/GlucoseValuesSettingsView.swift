import SwiftUI

struct GlucoseValuesSettingsView: View {
    @EnvironmentObject var preferenceService: PreferenceService

    var body: some View {
        VStack{
            Image("SettingsBgTarget")
                .resizable()
                .scaledToFit()
                .padding(.horizontal, 64)
            
            Form {
                Section(header: Text("Target range")) {
                    HStack {
                        Text("Low")
                        Spacer()
                        TextField("Low bound",
                                  value: $preferenceService.bgLow,
                                  format: .number)
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.trailing)
                        .fixedSize(horizontal: true, vertical: true)
                    }
                    
                    HStack {
                        Text("High")
                        Spacer()
                        TextField("High bound",
                                  value: $preferenceService.bgHigh,
                                  format: .number)
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.trailing)
                        .fixedSize(horizontal: true, vertical: true)
                    }
                    
                    HStack {
                        Text("Very high")
                        Spacer()
                        TextField("High bound",
                                  value: $preferenceService.bgUpper,
                                  format: .number)
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.trailing)
                        .fixedSize(horizontal: true, vertical: true)
                    }
                }
            }
        }
    }
}
