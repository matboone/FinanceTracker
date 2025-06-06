//
//  Expense.swift
//  FinanceTracker
//
//  Created by Matthew Boone on 6/5/25.
//

import Foundation
import SwiftData

@Model
final class Expense: Identifiable {

    @Attribute(.unique) var id: UUID
    var title:  String
    var amount: Double
    var date:   Date

    init(title: String, amount: Double, date: Date = Date()) {
        self.id     = UUID()
        self.title  = title
        self.amount = amount
        self.date   = date
    }
}
