import SwiftUI
import AppKit

enum SettingsPane: String, CaseIterable, Identifiable {
    case general
    case breakExperience
    case reminders
    case smartPause
    case automations
    case about

    var id: String { rawValue }

    var title: String {
        switch self {
        case .general: return "General"
        case .breakExperience: return "Break"
        case .reminders: return "Reminders"
        case .smartPause: return "Smart Pause"
        case .automations: return "Automations"
        case .about: return "About"
        }
    }

    var systemImage: String {
        switch self {
        case .general: return "gearshape"
        case .breakExperience: return "eye"
        case .reminders: return "bell"
        case .smartPause: return "pause.circle"
        case .automations: return "bolt.badge.clock"
        case .about: return "info.circle"
        }
    }
}

struct SettingsRootView: View {
    @State private var selection: SettingsPane = .general

    var body: some View {
        NavigationSplitView {
            List(selection: $selection) {
                ForEach(SettingsPane.allCases) { pane in
                    Label(pane.title, systemImage: pane.systemImage)
                        .tag(pane)
                }
            }
            // Make the sidebar background consistently vibrant (no mixed opaque blocks).
            .scrollContentBackground(.hidden)
            .background(
                // Use withinWindow so the sidebar tint matches System Settings (no weird wallpaper/brown bleed).
                VisualEffectView(material: .sidebar, blendingMode: .withinWindow, state: .active)
                    .ignoresSafeArea()
            )
            .navigationSplitViewColumnWidth(min: 180, ideal: 220)
        } detail: {
            Group {
                switch selection {
                case .general:
                    GeneralSettingsView()
                case .breakExperience:
                    BreakExperienceSettingsView()
                case .reminders:
                    RemindersSettingsView()
                case .smartPause:
                    SmartPauseSettingsView()
                case .automations:
                    AutomationsSettingsView()
                case .about:
                    AboutSettingsView()
                }
            }
            // System Settings-like split:
            // - Sidebar is vibrant
            // - Detail is opaque and the SAME color as the titlebar
            // - Content can scroll underneath, but is visually masked by the opaque titlebar
            .scrollContentBackground(.hidden)
            .background(Color(nsColor: .windowBackgroundColor).ignoresSafeArea())
            // Separator only for the right/detail panel (not the sidebar).
            .overlay(alignment: .top) {
                Rectangle()
                    .fill(Color.black.opacity(0.35))
                    .frame(height: 1)
            }
            .frame(minWidth: 520, minHeight: 420)
        }
        .navigationSplitViewStyle(.balanced)
    }
}
