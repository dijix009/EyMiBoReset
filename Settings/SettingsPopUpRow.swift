import SwiftUI

/// A System Settings-like row: left label + right "pop-up button" picker.
///
/// Uses `Picker(.menu)` so it renders like the native pop-up (e.g. Appearance > Sidebar icon size).
struct SettingsPopUpRow: View {
    let title: String
    let help: String?
    let values: [Int]
    let defaultValue: Int
    let unit: String
    @Binding var selection: Int

    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                if let help {
                    Text(help)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            Spacer()

            Picker("", selection: $selection) {
                // If selection isn't in the preset list, show it as "Custom" so the UI stays consistent.
                if !values.contains(selection) {
                    Text("Custom (\(selection) \(unit))").tag(selection)
                }

                ForEach(values, id: \.self) { v in
                    if v == defaultValue {
                        Text("\(v) \(unit) (default)").tag(v)
                    } else {
                        Text("\(v) \(unit)").tag(v)
                    }
                }
            }
            .labelsHidden()
            .pickerStyle(.menu)
            .frame(width: 140, alignment: .trailing)
        }
    }
}
