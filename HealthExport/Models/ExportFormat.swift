import Foundation

// MARK: - Export Format

enum ExportFormat: String, CaseIterable, Identifiable {
    case json = "JSON"
    case csv = "CSV"

    var id: String { rawValue }

    var fileExtension: String {
        switch self {
        case .json: "json"
        case .csv: "csv"
        }
    }

    var mimeType: String {
        switch self {
        case .json: "application/json"
        case .csv: "text/csv"
        }
    }
}

// MARK: - Date Range

enum DateRange: String, CaseIterable, Identifiable {
    case week = "7 Days"
    case month = "30 Days"
    case quarter = "90 Days"
    case year = "1 Year"
    case custom = "Custom"

    var id: String { rawValue }

    var startDate: Date? {
        let calendar = Calendar.current
        switch self {
        case .week: return calendar.date(byAdding: .day, value: -7, to: Date())
        case .month: return calendar.date(byAdding: .day, value: -30, to: Date())
        case .quarter: return calendar.date(byAdding: .day, value: -90, to: Date())
        case .year: return calendar.date(byAdding: .year, value: -1, to: Date())
        case .custom: return nil
        }
    }
}
