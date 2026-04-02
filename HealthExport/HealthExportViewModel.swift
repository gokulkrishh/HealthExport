import SwiftUI
import HealthKit

@MainActor
@Observable
final class HealthExportViewModel {
    var hasCompletedOnboarding: Bool = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding") {
        didSet { UserDefaults.standard.set(hasCompletedOnboarding, forKey: "hasCompletedOnboarding") }
    }
    var selectedCategories: Set<String> = []
    var dateRange: DateRange = .month
    var customStartDate = Calendar.current.date(byAdding: .month, value: -1, to: Date()) ?? Date()
    var customEndDate = Date()
    var exportFormat: ExportFormat = .json
    var isExporting = false
    var exportProgress: Double = 0
    var exportedFileURL: URL?
    var showShareSheet = false
    var errorMessage: String?
    var showError = false

    private let healthKitManager = HealthKitManager()

    // MARK: - Computed Properties

    var isHealthKitAvailable: Bool {
        HKHealthStore.isHealthDataAvailable()
    }

    var allCategories: [HealthCategory] {
        HealthCategory.allCategories
    }

    var selectedCategoryCount: Int {
        selectedCategories.count
    }

    var startDate: Date {
        dateRange == .custom ? customStartDate : (dateRange.startDate ?? customStartDate)
    }

    var endDate: Date {
        dateRange == .custom ? customEndDate : Date()
    }

    // MARK: - Category Management

    func categories(for group: HealthCategoryGroup) -> [HealthCategory] {
        allCategories.filter { $0.group == group }
    }

    func isSelected(_ category: HealthCategory) -> Bool {
        selectedCategories.contains(category.id)
    }

    func toggle(_ category: HealthCategory) {
        if selectedCategories.contains(category.id) {
            selectedCategories.remove(category.id)
        } else {
            selectedCategories.insert(category.id)
        }
    }

    func selectAll() {
        selectedCategories = Set(allCategories.map(\.id))
    }

    func deselectAll() {
        selectedCategories.removeAll()
    }

    // MARK: - Export

    func exportData() async {
        guard !selectedCategories.isEmpty else {
            errorMessage = "Please select at least one category to export."
            showError = true
            return
        }

        let selected = allCategories.filter { selectedCategories.contains($0.id) }

        isExporting = true
        exportProgress = 0

        do {
            try await healthKitManager.requestAuthorization(for: selected)

            var allData: [String: [HealthDataPoint]] = [:]

            for (index, category) in selected.enumerated() {
                let points = try await healthKitManager.fetchData(
                    for: category,
                    from: startDate,
                    to: endDate
                )
                if !points.isEmpty {
                    allData[category.name] = points
                }
                exportProgress = Double(index + 1) / Double(selected.count)
            }

            if allData.isEmpty {
                errorMessage = "No data found for the selected categories and date range."
                showError = true
                isExporting = false
                return
            }

            let fileData: Data
            switch exportFormat {
            case .json:
                fileData = try ExportService.exportToJSON(data: allData, startDate: startDate, endDate: endDate)
            case .csv:
                let csvString = ExportService.exportToCSV(data: allData)
                fileData = Data(csvString.utf8)
            }

            exportedFileURL = try ExportService.writeToTemporaryFile(data: fileData, format: exportFormat)
            showShareSheet = true
        } catch let error as HKError where error.code == .errorAuthorizationDenied {
            errorMessage = "Health data access was denied. Please enable permissions in Settings > Privacy & Security > Health."
            showError = true
        } catch let error as HKError where error.code == .errorAuthorizationNotDetermined {
            errorMessage = "Health data access needs to be granted. Please try exporting again."
            showError = true
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }

        isExporting = false
    }
}
