import SwiftUI

struct IntroView: View {
    @EnvironmentObject private var prefs: PreferenceService

    var body: some View {
        ThemedScreen {
            VStack {
                Image("OnboardLogo")
                    .resizable()
                    .scaledToFit()
                    .padding(.vertical, 32)
                    .padding(.horizontal, 64)
                    .frame(maxHeight: UIScreen.main.bounds.height * 0.3)

                Spacer()

                ThemedSection {
                    VStack(alignment: .leading) {
                        Text("Welcome to \(SugarScopeApp.APP_NAME)")
                            .font(.title)
                            .fontWeight(.semibold)

                        Text("Beautiful blood glucose visualization for diabetics")
                            .font(.subheadline)
                            .fontWeight(.light)

                        Spacer()

                        VStack(spacing: 16) {
                            OnboardFeatureItem("hourglass", "Instant insight", "Quickly see your current and past levels without thinking")
                            OnboardFeatureItem("hourglass", "Instant insight", "Quickly see your current and past levels without thinking")
                            OnboardFeatureItem("hourglass", "Instant insight", "Quickly see your current and past levels without thinking")
                        }

                        Spacer()

                        ThemedNavigationButton("Get started", ConnectionTypeView())
                    }
                    .padding(16)
                }
                .foregroundStyle(prefs.theme.textColor)
            }
        }
    }
}

struct OnboardFeatureItem: View {
    let icon: String
    let title: String
    let description: String

    init(_ icon: String, _ title: String, _ description: String) {
        self.icon = icon
        self.title = title
        self.description = description
    }

    var body: some View {
        HStack(spacing: 0) {
            Image(systemName: icon)
                .font(.system(size: 38))
                .padding(.leading, 0)
                .padding(.trailing, 16)

            VStack(alignment: .leading, spacing: 0) {
                Text(title)
                    .font(.callout)
                    .fontWeight(.semibold)

                Text(description)
                    .font(.footnote)
                    .fontWeight(.light)
            }
        }
    }
}
