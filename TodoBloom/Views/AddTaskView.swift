import SwiftUI

struct AddTaskView: View {
    @EnvironmentObject private var store: TaskStore
    @Environment(\.dismiss) private var dismiss
    @State private var title = ""
    @State private var notes = ""
    @State private var priority: TaskPriority = .medium
    @State private var includesDueDate = true
    @State private var dueDate = Date.now

    var body: some View {
        NavigationStack {
            Form {
                Section("What needs doing?") {
                    TextField("Task title", text: $title, axis: .vertical)
                    TextField("Notes (optional)", text: $notes, axis: .vertical)
                }
                Section("Plan") {
                    Picker("Priority", selection: $priority) { ForEach(TaskPriority.allCases) { Text($0.title).tag($0) } }
                    Toggle("Due date", isOn: $includesDueDate)
                    if includesDueDate { DatePicker("When", selection: $dueDate, displayedComponents: .date) }
                }
            }
            .navigationTitle("New task")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") { store.add(TodoItem(title: title.trimmingCharacters(in: .whitespacesAndNewlines), notes: notes.trimmingCharacters(in: .whitespacesAndNewlines), dueDate: includesDueDate ? dueDate : nil, priority: priority)); dismiss() }
                        .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
}

