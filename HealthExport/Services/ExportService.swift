import Foundation

struct ExportService {

    // MARK: - JSON Export

    static func exportToJSON(data: [String: [HealthDataPoint]], startDate: Date, endDate: Date) throws -> Data {
        let export = HealthExportPayload(
            exportDate: Date(),
            startDate: startDate,
            endDate: endDate,
            data: data
        )
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        return try encoder.encode(export)
    }

    // MARK: - CSV Export

    static func exportToCSV(data: [String: [HealthDataPoint]]) -> String {
        var csv = "Category,Start Date,End Date,Value,Unit,Metadata\n"

        let formatter = ISO8601DateFormatter()

        for (_, points) in data.sorted(by: { $0.key < $1.key }) {
            for point in points {
                let startStr = formatter.string(from: point.startDate)
                let endStr = formatter.string(from: point.endDate)
                let meta = csvEscape(point.metadata ?? "")

                csv += "\(csvEscape(point.category)),\(startStr),\(endStr),\(point.value),\(csvEscape(point.unit)),\(meta)\n"
            }
        }

        return csv
    }

    // MARK: - File Creation

    static func writeToTemporaryFile(data: Data, format: ExportFormat) throws -> URL {
        let timestamp = Self.fileDateFormatter.string(from: Date())
        let fileName = "HealthExport_\(timestamp).\(format.fileExtension)"
        let url = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
        try data.write(to: url)
        return url
    }

    // MARK: - Helpers

    private static func csvEscape(_ value: String) -> String {
        if value.contains(",") || value.contains("\"") || value.contains("\n") {
            return "\"\(value.replacingOccurrences(of: "\"", with: "\"\""))\""
        }
        return value
    }

    private static let fileDateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd_HHmmss"
        return f
    }()
}

// MARK: - Export Payload

struct HealthExportPayload: Codable {
    let exportDate: Date
    let startDate: Date
    let endDate: Date
    let data: [String: [HealthDataPoint]]
}
