import Foundation

extension DateFormatter {
    
    /// dateFormater format: "HH:mm dd-MM-yyyy"
    static let full: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm dd-MM-yyyy"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }()
}
