import SwiftUI
import SwiftData

@main
struct FinanceTrackerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(
                    for: [Expense.self, Item.self]   // ← list each @Model here
                )
        }
    }
}
