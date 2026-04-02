import SwiftUI

struct ExportView: View {
    @Bindable var viewModel: HealthExportViewModel

    var body: some View {
        NavigationStack {
            Form {
                // Summary
                Section {
                    Label(
                        "\(viewModel.selectedCategoryCount) categories selected",
                        systemImage: viewModel.selectedCategories.isEmpty
                            ? "circle.dashed"
                            : "checkmark.circle.fill"
                    )
                    .foregroundStyle(viewModel.selectedCategories.isEmpty ? .secondary : .primary)
                }

                // Date Range
                Section("Date Range") {
                    Picker("Period", selection: $viewModel.dateRange) {
                        ForEach(DateRange.allCases) { range in
                            Text(range.rawValue).tag(range)
                        }
                    }

                    if viewModel.dateRange == .custom {
                        DatePicker("From", selection: $viewModel.customStartDate, displayedComponents: .date)
                        DatePicker("To", selection: $viewModel.customEndDate, displayedComponents: .date)
                    }
                }

                // Format
                Section("Format") {
                    Picker("Format", selection: $viewModel.exportFormat) {
                        ForEach(ExportFormat.allCases) { format in
                            Text(format.rawValue).tag(format)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                // Export Button
                Section {
                    Button {
                        Task { await viewModel.exportData() }
                    } label: {
                        HStack {
                            Spacer()
                            if viewModel.isExporting {
                                ProgressView()
                                    .padding(.trailing, 8)
                                Text("Exporting...")
                            } else {
                                Label("Export Data", systemImage: "square.and.arrow.up")
                                    .font(.headline)
                            }
                            Spacer()
                        }
                        .padding(.vertical, 4)
                    }
                    .disabled(viewModel.selectedCategories.isEmpty || viewModel.isExporting)
                }

                // Progress
                if viewModel.isExporting {
                    Section {
                        ProgressView(value: viewModel.exportProgress) {
                            Text("Fetching health data...")
                        }
                    }
                }
            }
            .navigationTitle("Export")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $viewModel.showShareSheet) {
                if let url = viewModel.exportedFileURL {
                    ShareSheet(items: [url])
                }
            }
            .alert("Error", isPresented: $viewModel.showError) {
                Button("OK") {}
                if viewModel.errorMessage?.contains("Settings") == true {
                    Button("Open Settings") {
                        if let url = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(url)
                        }
                    }
                }
            } message: {
                Text(viewModel.errorMessage ?? "An unknown error occurred.")
            }
        }
    }
}

// MARK: - Share Sheet

struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
