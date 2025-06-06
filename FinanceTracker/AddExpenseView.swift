//
//  AddExpenseView.swift
//  FinanceTracker
//
//  Created by Matthew Boone on 6/5/25.
//

import SwiftUI
import SwiftData

struct AddExpenseView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss)     private var dismiss

    // Form state
    @State private var title  = ""
    @State private var amount = ""
    @State private var date   = Date()

    var body: some View {
        NavigationStack {
            Form {
                Section("Details") {
                    TextField("Title", text: $title)

                    TextField("Amount", text: $amount)
                        .keyboardType(.decimalPad)

                    DatePicker("Date",
                               selection: $date,
                               displayedComponents: .date)
                }
            }
            .navigationTitle("New Expense")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save")   { save() }
                        .disabled(!formIsValid)
                }
            }
        }
    }

    private var formIsValid: Bool {
        !title.trimmingCharacters(in: .whitespaces).isEmpty &&
        Double(amount) != nil
    }

    private func save() {
        guard let value = Double(amount) else { return }
        let newExpense = Expense(title: title, amount: value, date: date)
        context.insert(newExpense)
        try? context.save()
        dismiss()
    }
}
