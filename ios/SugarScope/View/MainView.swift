import SwiftUI

struct MainView: View {
    @ObservedObject
    private var dataService: DataSourceService = .init()

    var body: some View {
        ZStack(alignment: .top) {
//            VStack {
//                HStack {
//                    Spacer()
//                    Button(action: {}) {
//                        Image(systemName: "ellipsis")
//                    }
//                    .padding(4)
//                }
//                Spacer()
//            }

            if let datasource = dataService.datasource {
                GraphView(datasource)
            }
            else {
                ConfigurationWizard { conf in
                    self.dataService.saveConfiguration(conf)
                }
            }
        }
        .onAppear(){
//            dataSerivce.clearConfiguration()
        }
    }
}
