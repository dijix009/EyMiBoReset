import SwiftUI

struct ReminderPopupView: View {
    let title: String
    let subtitle: String
    let isInteractive: Bool
    let snoozeMinutes: Int
    let onSnooze: (() -> Void)?
    let onDismiss: (() -> Void)?

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 18, weight: .semibold))

            Text(subtitle)
                .font(.system(size: 13))
                .foregroundStyle(.secondary)

            if isInteractive {
                HStack(spacing: 10) {
                    Spacer()
                    Button("Snooze \(snoozeMinutes) min") {
                        onSnooze?()
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.small)
                }
                .padding(.top, 2)
            }
        }
        .padding(.vertical, isInteractive ? 10 : 12)
        .padding(.horizontal, 14)
        .frame(maxWidth: 300, alignment: .leading)
        .background(
            VisualEffectView(material: .hudWindow, blendingMode: .withinWindow, state: .active)
                .clipShape(RoundedRectangle(cornerRadius: 24, style: .circular))
        )
        .shadow(color: Color.black.opacity(0.12), radius: 12, x: 0, y: 8)
        .padding(26)
        .contentShape(RoundedRectangle(cornerRadius: 24, style: .circular))
        .onTapGesture {
            onDismiss?()
        }
    }
}
