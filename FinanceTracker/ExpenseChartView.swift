//
//  ExpenseChartView.swift
//  FinanceTracker
//
//  Created by Matthew Boone on 6/5/25.
//

import SwiftUI
import SwiftData
import Charts    // ← we just linked Charts.framework

struct ExpenseChartView: View {
    // Fetch every expense, sorted by date ascending (so we can group correctly)
    @Query(sort: \Expense.date, order: .forward) private var allExpenses: [Expense]

    // Compute an array of (Date, totalAmount) for each of the last 7 days
    private var last7DaysTotals: [(day: Date, total: Double)] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        // Build an array of Date objects for: today, yesterday, … back to 6 days ago
        let days: [Date] = (0..<7).map { offset in
            calendar.date(byAdding: .day, value: -offset, to: today)!
        }.reversed() // reverse so oldest day comes first

        // For each day, sum up all expense.amounts whose date is "in that day"
        return days.map { dayStart in
            let dayEnd = calendar.date(byAdding: .day, value: 1, to: dayStart)!
            let total: Double = allExpenses
                .filter { $0.date >= dayStart && $0.date < dayEnd }
                .reduce(0) { $0 + $1.amount }
            return (day: dayStart, total: total)
        }
    }

    var body: some View {
        VStack {
            Text("Last 7 Days Spending")
                .font(.title2.bold())
                .padding(.top, 8)

            Chart {
                ForEach(last7DaysTotals, id: \.day) { entry in
                    BarMark(
                        x: .value("Day", entry.day, unit: .day),
                        y: .value("Total spent", entry.total)
                    )
                    .foregroundStyle(.blue.gradient)
                    // Simple color gradient; change as you like
                }
            }
            .chartXAxis {
                AxisMarks(values: .stride(by: .day)) { value in
                    AxisGridLine()
                    AxisValueLabel(format: .dateTime.weekday(.abbreviated))
                }
            }
            .chartYAxis {
                AxisMarks(position: .leading) {
                    AxisValueLabel()
                    AxisGridLine()
                }
            }
            .padding()
        }
        .navigationTitle("Spending Chart")
    }
}

#Preview {
    // A preview that injects dummy data in memory so the chart renders in Canvas
    ExpenseChartView()
        .modelContainer(
            for: Expense.self,
            inMemory: true
        )
}
