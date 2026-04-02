import SwiftUI

struct OnboardingView: View {
    @Bindable var viewModel: HealthExportViewModel

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            Image(systemName: "heart.fill")
                .font(.system(size: 72))
                .foregroundStyle(.pink)

            Text("HealthExport")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("Select your Apple Health categories and export them as JSON or CSV — all on device.")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)

            Spacer()

            Button {
                viewModel.hasCompletedOnboarding = true
            } label: {
                Text("Get Started")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
            }
            .buttonStyle(.borderedProminent)
            .tint(.pink)
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
        }
    }
}
