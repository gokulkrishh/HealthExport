import SwiftUI
import HealthKit

struct ContentView: View {
    @State private var viewModel = HealthExportViewModel()

    var body: some View {
        if viewModel.isHealthKitAvailable {
            TabView {
                Tab("Categories", systemImage: "list.bullet") {
                    CategoryListView(viewModel: viewModel)
                }

                Tab("Export", systemImage: "square.and.arrow.up") {
                    ExportView(viewModel: viewModel)
                }
                .badge(viewModel.selectedCategoryCount)
            }
        } else {
            ContentUnavailableView(
                "Health Data Unavailable",
                systemImage: "heart.slash",
                description: Text("HealthKit is not available on this device.")
            )
        }
    }
}

#Preview {
    ContentView()
}
