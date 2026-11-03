import SwiftUI

struct TaskRow: View {
    @EnvironmentObject private var store: TaskStore
    let task: TodoItem

    var body: some View {
        HStack(alignment: .top, spacing: 13) {
            Button { withAnimation(.snappy) { store.toggle(task) } } label: {
                Image(systemName: task.isComplete ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundStyle(task.isComplete ? .green : .secondary)
            }
            .buttonStyle(.plain)
            VStack(alignment: .leading, spacing: 6) {
                Text(task.title)
                    .font(.body.weight(.semibold))
                    .strikethrough(task.isComplete, color: .secondary)
                    .foregroundStyle(task.isComplete ? .secondary : .primary)
                if !task.notes.isEmpty { Text(task.notes).font(.caption).foregroundStyle(.secondary).lineLimit(1) }
                HStack(spacing: 10) {
                    Label(task.priority.title, systemImage: task.priority.symbol)
                    if let dueDate = task.dueDate {
                        Label(dueDate.formatted(date: .abbreviated, time: .omitted), systemImage: "calendar")
                            .foregroundStyle(task.isOverdue ? .red : .secondary)
                    }
                }
                .font(.caption2.weight(.medium))
                .foregroundStyle(task.priority == .high ? .red : .secondary)
            }
            Spacer()
        }
        .padding(16)
        .background(.background, in: RoundedRectangle(cornerRadius: 18))
        .contextMenu { Button(role: .destructive) { store.delete(task) } label: { Label("Delete", systemImage: "trash") } }
    }
}

