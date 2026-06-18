import SwiftUI

struct AboutSettingsView: View {
    var body: some View {
        Form {
            Section {
                Image(nsImage: NSApp.applicationIconImage)
                    .resizable()
                    .interpolation(.high)
                    .frame(width: 64, height: 64)
                    .cornerRadius(14)
                    .padding(.bottom, 4)

                Text("EyMiBo Reset")
                    .font(.title3.weight(.semibold))

                Text("Smart breaks for focused work.")
                    .foregroundStyle(.secondary)

                Text("Version 1.0")
                    .foregroundStyle(.secondary)

                Text("Menu bar: EMB")
                    .foregroundStyle(.secondary)

                Text("Bundle: com.dj.EyMiBoReset")
                    .foregroundStyle(.secondary)
            } header: {
                Text("About")
            }
        }
        .formStyle(.grouped)
        .navigationTitle("About")
    }
}
