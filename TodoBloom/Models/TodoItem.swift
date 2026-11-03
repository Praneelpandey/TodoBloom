import Foundation

enum TaskPriority: String, CaseIterable, Codable, Identifiable {
    case low, medium, high

    var id: String { rawValue }
    var title: String { rawValue.capitalized }
    var symbol: String {
        switch self {
        case .low: return "arrow.down"
        case .medium: return "equal"
        case .high: return "arrow.up"
        }
    }
}

struct TodoItem: Identifiable, Codable, Equatable {
    let id: UUID
    var title: String
    var notes: String
    var dueDate: Date?
    var priority: TaskPriority
    var isComplete: Bool
    let createdAt: Date

    init(id: UUID = UUID(), title: String, notes: String = "", dueDate: Date? = nil, priority: TaskPriority = .medium, isComplete: Bool = false, createdAt: Date = .now) {
        self.id = id
        self.title = title
        self.notes = notes
        self.dueDate = dueDate
        self.priority = priority
        self.isComplete = isComplete
        self.createdAt = createdAt
    }

    var isDueToday: Bool { dueDate.map { Calendar.current.isDateInToday($0) } ?? false }
    var isOverdue: Bool { dueDate.map { $0 < Calendar.current.startOfDay(for: .now) && !isComplete } ?? false }
}

