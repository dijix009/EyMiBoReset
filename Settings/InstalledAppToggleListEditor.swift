import AppKit
import SwiftUI

/// Apple-like editor: show installed apps (icon + name) with a toggle.
///
/// - `allRawText`: the master list of apps to show (enabled or disabled)
/// - `enabledRawText`: the subset that's currently enabled
///
/// Values are stored as newline-separated bundle identifiers.
struct InstalledAppToggleListEditor: View {
    let title: String
    let help: String?

    @Binding var allRawText: String
    @Binding var enabledRawText: String

    @State private var showAdvanced = false
    @State private var newId: String = ""

    /// Hide the manual bundle-id entry UI. For normal users, Add App… is enough.
    var showAdvancedSection: Bool = false

    private struct AppInfo: Identifiable {
        let id: String
        let displayName: String
        let icon: NSImage
    }

    private var allIds: [String] { UserSettings.parseBundleIdList(allRawText) }
    private var enabledIds: Set<String> { Set(UserSettings.parseBundleIdList(enabledRawText)) }

    private var installedApps: [AppInfo] {
        let unique = Array(Set(allIds)).sorted()
        return unique.compactMap { bundleId in
            guard let url = NSWorkspace.shared.urlForApplication(withBundleIdentifier: bundleId) else {
                return nil // only show installed apps
            }

            let name: String
            if let bundle = Bundle(url: url) {
                let display = (bundle.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String)
                let bundleName = (bundle.object(forInfoDictionaryKey: "CFBundleName") as? String)
                name = display ?? bundleName ?? url.deletingPathExtension().lastPathComponent
            } else {
                name = url.deletingPathExtension().lastPathComponent
            }

            let icon = NSWorkspace.shared.icon(forFile: url.path)
            icon.size = NSSize(width: 64, height: 64)

            return .init(id: bundleId, displayName: name, icon: icon)
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .firstTextBaseline) {
                Text(title)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Spacer()

                Button("Add App…") { addFromAppPicker() }
            }

            List {
                if installedApps.isEmpty {
                    Text("No installed apps in this list")
                        .foregroundStyle(.secondary)
                }

                ForEach(installedApps) { app in
                    HStack(spacing: 10) {
                        Image(nsImage: app.icon)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 18, height: 18)

                        Text(app.displayName)
                            .font(.body)

                        Spacer()

                        Toggle("", isOn: bindingForEnabled(app.id))
                            .labelsHidden()
                            .toggleStyle(.switch)
                            .controlSize(.small)
                    }
                    .padding(.vertical, 2)
                }
            }
            .frame(minHeight: 112)
            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))

            if showAdvancedSection {
                DisclosureGroup("Advanced", isExpanded: $showAdvanced) {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            TextField("Bundle identifier (e.g. us.zoom.xos)", text: $newId)
                                .textFieldStyle(.roundedBorder)
                                .font(.system(.body, design: .monospaced))
                                .onSubmit { addManual() }

                            Button("Add") { addManual() }
                                .disabled(newId.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                        }

                        Text("This app will be added and enabled by default.")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.top, 6)
                }
            }

            if let help, !help.isEmpty {
                Text(help)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }

    // MARK: - Bindings

    private func bindingForEnabled(_ id: String) -> Binding<Bool> {
        Binding(
            get: { enabledIds.contains(id) },
            set: { isOn in
                if isOn {
                    enable(id)
                } else {
                    disable(id)
                }
            }
        )
    }

    // MARK: - Mutations

    private func normalizeAndSet(all: [String], enabled: [String]) {
        allRawText = Array(Set(all)).sorted().joined(separator: "\n")
        enabledRawText = Array(Set(enabled)).sorted().joined(separator: "\n")
    }

    private func enable(_ id: String) {
        let all = Array(Set(allIds + [id]))
        let enabled = Array(enabledIds.union([id]))
        normalizeAndSet(all: all, enabled: enabled)
    }

    private func disable(_ id: String) {
        let all = allIds
        var enabled = enabledIds
        enabled.remove(id)
        normalizeAndSet(all: all, enabled: Array(enabled))
    }

    private func addManual() {
        let trimmed = newId.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        enable(trimmed) // added + enabled by default
        newId = ""
    }

    private func addFromAppPicker() {
        let panel = NSOpenPanel()
        panel.canChooseFiles = true
        panel.canChooseDirectories = false
        panel.allowsMultipleSelection = false
        panel.allowedContentTypes = [.application]
        panel.prompt = "Add"

        panel.begin { response in
            guard response == .OK, let url = panel.url else { return }
            guard let bundle = Bundle(url: url), let id = bundle.bundleIdentifier else { return }
            DispatchQueue.main.async { enable(id) } // enabled by default
        }
    }
}
