import SwiftUI

struct SettingsView: View {
    private var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    }

    private var buildNumber: String {
        Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
    }

    var body: some View {
        NavigationStack {
            List {
                Section("About") {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("\(appVersion) (\(buildNumber))")
                            .foregroundStyle(.secondary)
                    }
                }

                Section("Health Data") {
                    Button {
                        if let url = URL(string: "x-apple-health://") {
                            UIApplication.shared.open(url)
                        }
                    } label: {
                        Label("Open Health App", systemImage: "heart.fill")
                    }
                    .foregroundStyle(.primary)

                    Button {
                        if let url = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(url)
                        }
                    } label: {
                        Label("Manage Permissions", systemImage: "lock.shield.fill")
                    }
                    .foregroundStyle(.primary)
                }

                Section {
                    NavigationLink {
                        PrivacyPolicyView()
                    } label: {
                        Label("Privacy Policy", systemImage: "hand.raised.fill")
                    }
                    .foregroundStyle(.primary)

                    Link(destination: URL(string: "https://github.com/gokulkrishh/HealthExport")!) {
                        Label("Source Code", systemImage: "chevron.left.forwardslash.chevron.right")
                    }
                    .foregroundStyle(.primary)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
