import SwiftUI

struct CategoryListView: View {
    var viewModel: HealthExportViewModel

    var body: some View {
        NavigationStack {
            List {
                ForEach(HealthCategoryGroup.allCases) { group in
                    Section {
                        ForEach(viewModel.categories(for: group)) { category in
                            Toggle(isOn: Binding(
                                get: { viewModel.isSelected(category) },
                                set: { _ in viewModel.toggle(category) }
                            )) {
                                Label(category.name, systemImage: category.icon)
                            }
                        }
                    } header: {
                        Label(group.rawValue, systemImage: group.icon)
                    }
                }
            }
            .navigationTitle("HealthExport")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Menu {
                        Button("Select All", systemImage: "checkmark.circle.fill") {
                            viewModel.selectAll()
                        }
                        Button("Deselect All", systemImage: "circle") {
                            viewModel.deselectAll()
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
            }
        }
    }
}
