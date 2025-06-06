//
//  Item.swift
//  FinanceTracker
//
//  Created by Matthew Boone on 6/5/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
