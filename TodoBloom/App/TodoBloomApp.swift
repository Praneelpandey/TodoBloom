import SwiftUI

@main
struct TodoBloomApp: App {
    @StateObject private var store = TaskStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
                .tint(.indigo)
        }
    }
}

