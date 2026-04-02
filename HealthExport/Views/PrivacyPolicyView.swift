import SwiftUI

struct PrivacyPolicyView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Group {
                    section(
                        title: "Privacy Policy",
                        body: "Last updated: April 2, 2026\n\nHealthExport is committed to protecting your privacy. This policy explains how the app handles your data."
                    )

                    section(
                        title: "Data Collection",
                        body: "HealthExport does not collect, store, or transmit any of your health data to external servers. All data processing happens entirely on your device."
                    )

                    section(
                        title: "Health Data Access",
                        body: "The app requests read-only access to Apple Health data categories that you explicitly select. This data is used solely to generate export files (JSON or CSV) on your device."
                    )

                    section(
                        title: "Data Storage",
                        body: "HealthExport does not maintain its own database of your health data. Exported files are created as temporary files on your device and are only shared when you explicitly choose to via the share sheet."
                    )

                    section(
                        title: "Third-Party Services",
                        body: "HealthExport does not integrate with any third-party analytics, advertising, or tracking services. No data leaves your device unless you choose to share an exported file."
                    )

                    section(
                        title: "Your Control",
                        body: "You can revoke HealthExport's access to your health data at any time through Settings > Privacy & Security > Health on your device."
                    )

                    section(
                        title: "Contact",
                        body: "If you have questions about this privacy policy, please open an issue on our GitHub repository."
                    )
                }
            }
            .padding()
        }
        .navigationTitle("Privacy Policy")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func section(title: String, body: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
            Text(body)
                .font(.body)
                .foregroundStyle(.secondary)
        }
    }
}
