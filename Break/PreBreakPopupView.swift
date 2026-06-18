import SwiftUI

struct PreBreakPopupView: View {
    @ObservedObject var session: PreBreakPopupSession
    let onStart: () -> Void
    let onSnooze: () -> Void
    let onSkip: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .firstTextBaseline) {
                Text("Upcoming break")
                    .font(.system(size: 16, weight: .semibold))
                Spacer()
                Text("\(session.remaining)s")
                    .font(.system(size: 13, weight: .medium, design: .monospaced))
                    .foregroundStyle(.secondary)
            }

            Text("Your eye break will start automatically.")
                .font(.system(size: 13))
                .foregroundStyle(.secondary)

            HStack(spacing: 10) {
                Button("Start now", action: onStart)
                    .buttonStyle(.borderedProminent)

                Button("Snooze", action: onSnooze)
                    .buttonStyle(.bordered)

                Button("Skip", action: onSkip)
                    .buttonStyle(.bordered)
            }
        }
        .padding(.vertical, 14)
        .padding(.horizontal, 16)
        .frame(width: 420)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(Color.white.opacity(0.12), lineWidth: 1)
        )
    }
}
