import Foundation

enum TaskFilter: String, CaseIterable, Identifiable {
    case today = "Today"
    case upcoming = "Upcoming"
    case completed = "Completed"

    var id: String { rawValue }
}

