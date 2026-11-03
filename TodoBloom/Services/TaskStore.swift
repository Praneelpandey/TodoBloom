import Foundation

@MainActor
final class TaskStore: ObservableObject {
    @Published private(set) var tasks: [TodoItem] = [] { didSet { save() } }
    private let storageKey = "todobloom.tasks.v1"

    init() {
        guard let data = UserDefaults.standard.data(forKey: storageKey),
              let saved = try? JSONDecoder().decode([TodoItem].self, from: data) else { return }
        tasks = saved
    }

    func add(_ task: TodoItem) { tasks.insert(task, at: 0) }
    func toggle(_ task: TodoItem) { update(task) { $0.isComplete.toggle() } }
    func delete(_ task: TodoItem) { tasks.removeAll { $0.id == task.id } }
    func update(_ task: TodoItem, transform: (inout TodoItem) -> Void) {
        guard let index = tasks.firstIndex(of: task) else { return }
        transform(&tasks[index])
    }

    var openCount: Int { tasks.filter { !$0.isComplete }.count }
    var todayCount: Int { tasks.filter { $0.isDueToday && !$0.isComplete }.count }
    var completedCount: Int { tasks.filter(\.isComplete).count }

    private func save() {
        guard let data = try? JSONEncoder().encode(tasks) else { return }
        UserDefaults.standard.set(data, forKey: storageKey)
    }
}

