import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \Expense.date, order: .reverse) private var expenses: [Expense]
    @State private var showingAdd = false
    @State private var selectedTab = 0   // 0 = list, 1 = chart

    var body: some View {
        TabView(selection: $selectedTab) {
            // ─── Tab #1: Expense List ───
            NavigationStack {
                List(expenses) { exp in
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(exp.title).fontWeight(.semibold)
                            Text(exp.date, format: .dateTime.month().day().year())
                                .font(.caption).foregroundStyle(.secondary)
                        }
                        Spacer()
                        Text(exp.amount,
                             format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                    }
                }
                .navigationTitle("Expenses")
                .toolbar {
                    Button { showingAdd = true } label: {
                        Image(systemName: "plus")
                    }
                }
                .sheet(isPresented: $showingAdd) {
                    AddExpenseView()
                }
                .onAppear { insertSampleIfNeeded() }
            }
            .tabItem {
                Label("List", systemImage: "list.bullet")
            }
            .tag(0)

            // ─── Tab #2: Chart ───
            NavigationStack {
                ExpenseChartView()
            }
            .tabItem {
                Label("Chart", systemImage: "chart.bar.fill")
            }
            .tag(1)
        }
    }

    private func insertSampleIfNeeded() {
        guard expenses.isEmpty else { return }
        let demo = Expense(title: "Coffee", amount: 3.75)
        context.insert(demo)
        try? context.save()
    }
}

#Preview {
    ContentView()
        .modelContainer(
            for: Expense.self,
            inMemory: true
        )
}
