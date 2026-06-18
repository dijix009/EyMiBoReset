import SwiftUI

struct OverlayView: View {
    @ObservedObject var session: OverlaySession
    let title: String
    let subtitle: String
    let dimOpacity: Double
    let allowSkip: Bool
    let skipAfterSeconds: Int

    @State private var appeared = false

    var body: some View {
        ZStack {
            // Dim overlay (optional blur provided by NSVisualEffectView behind this hosting view).
            Color.black.opacity(dimOpacity).ignoresSafeArea()

            VStack(spacing: 14) {
                Text(title)
                    .font(.system(size: 26, weight: .semibold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)

                if !subtitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    Text(subtitle)
                        .font(.system(size: 15))
                        .foregroundColor(.white.opacity(0.85))
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 4)
                }

                Text("\(session.remaining)")
                    .font(.system(size: 56, weight: .bold, design: .rounded))
                    .foregroundColor(.white)

                if allowSkip {
                    let remainingToUnlock = max(0, skipAfterSeconds - session.elapsed)

                    Button(remainingToUnlock > 0 ? "Skip in \(remainingToUnlock)s" : "Skip break") {
                        session.skip()
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(remainingToUnlock > 0)
                }
            }
            .padding(24)
            .frame(maxWidth: 700)
        }
        .opacity(appeared ? 1 : 0)
        .animation(.easeInOut(duration: 0.18), value: appeared)
        .onAppear {
            appeared = true
            session.start()
        }
    }
}
