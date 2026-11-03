import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var store: TaskStore
    @State private var selectedFilter: TaskFilter = .today
    @State private var showingAddTask = false

    private var filteredTasks: [TodoItem] {
        let calendar = Calendar.current
        let filtered: [TodoItem]
        switch selectedFilter {
        case .today:
            filtered = store.tasks.filter { $0.isDueToday && !$0.isComplete }
        case .upcoming:
            filtered = store.tasks.filter { !$0.isComplete && ($0.dueDate == nil || $0.dueDate! >= calendar.startOfDay(for: .now)) }
        case .completed:
            filtered = store.tasks.filter(\.isComplete)
        }
        return filtered.sorted { left, right in
            if left.isComplete != right.isComplete { return !left.isComplete }
            if left.priority != right.priority { return priorityRank(left.priority) > priorityRank(right.priority) }
            return (left.dueDate ?? .distantFuture) < (right.dueDate ?? .distantFuture)
        }
    }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                Color(uiColor: .systemGroupedBackground).ignoresSafeArea()
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        hero
                        filterPicker
                        taskList
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 104)
                }
                Button { showingAddTask = true } label: {
                    Image(systemName: "plus")
                        .font(.title2.weight(.bold))
                        .frame(width: 58, height: 58)
                        .foregroundStyle(.white)
                        .background(.indigo.gradient, in: Circle())
                        .shadow(color: .indigo.opacity(0.32), radius: 16, y: 8)
                }
                .accessibilityLabel("Add task")
                .padding(24)
            }
            .navigationTitle("Todo Bloom")
            .sheet(isPresented: $showingAddTask) { AddTaskView() }
        }
    }

    private var hero: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(greeting).font(.title2.weight(.bold))
            Text("Small steps, beautifully done.")
                .foregroundStyle(.secondary)
            HStack(spacing: 12) {
                StatCard(value: "\(store.openCount)", label: "Open", tint: .indigo)
                StatCard(value: "\(store.todayCount)", label: "Today", tint: .orange)
                StatCard(value: "\(store.completedCount)", label: "Done", tint: .green)
            }
        }
        .padding(.top, 8)
    }

    private var filterPicker: some View {
        Picker("Task list", selection: $selectedFilter) {
            ForEach(TaskFilter.allCases) { Text($0.rawValue).tag($0) }
        }
        .pickerStyle(.segmented)
    }

    @ViewBuilder private var taskList: some View {
        if filteredTasks.isEmpty {
            ContentUnavailableView(selectedFilter == .completed ? "Nothing completed yet" : "Your list is clear", systemImage: selectedFilter == .completed ? "checkmark.circle" : "sparkles", description: Text(selectedFilter == .completed ? "Finished tasks will appear here." : "Add a task and make today count."))
                .frame(maxWidth: .infinity, minHeight: 250)
        } else {
            LazyVStack(spacing: 12) {
                ForEach(filteredTasks) { task in
                    TaskRow(task: task)
                }
            }
        }
    }

    private var greeting: String {
        switch Calendar.current.component(.hour, from: .now) {
        case 5..<12: "Good morning"
        case 12..<18: "Good afternoon"
        default: "Good evening"
        }
    }

    private func priorityRank(_ priority: TaskPriority) -> Int {
        switch priority {
        case .high: return 3
        case .medium: return 2
        case .low: return 1
        }
    }
}

private struct StatCard: View {
    let value: String
    let label: String
    let tint: Color
    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(value).font(.title2.weight(.bold)).foregroundStyle(tint)
            Text(label).font(.caption.weight(.medium)).foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(.background, in: RoundedRectangle(cornerRadius: 16))
    }
}

