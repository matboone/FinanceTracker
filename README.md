# FinanceTracker

**FinanceTracker** is a simple SwiftUI-based expense tracker that lets you:

* Add, list, and persist expenses locally using SwiftData.
* Visualize your spending over the last 7 days with a Swift Charts bar chart.
* Experience a clean, modern SwiftUI interface with real-time updates powered by SwiftData’s `@Query`.

This project is intended as a polished portfolio piece demonstrating core SwiftUI, SwiftData, and Swift Charts skills. It requires only a free Apple ID—no paid Developer Program membership required.

---

## Table of Contents

1. [Screenshots](#screenshots)
2. [Features](#features)
3. [Prerequisites](#prerequisites)
4. [Installation & Setup](#installation--setup)
5. [Project Structure](#project-structure)
6. [How to Use](#how-to-use)
7. [Tech Stack & Dependencies](#tech-stack--dependencies)
8. [License](#license)

---

## Screenshots

![Simulator Screenshot - iPhone 16 Pro - 2025-06-06 at 14 11 14](https://github.com/user-attachments/assets/cdbe5013-7109-406e-af4a-8a869319e1f9)
![Simulator Screenshot - iPhone 16 Pro - 2025-06-06 at 14 11 18](https://github.com/user-attachments/assets/8fffb599-4fa5-4f86-8569-74eabec95b6e)
![Simulator Screenshot - iPhone 16 Pro - 2025-06-06 at 14 11 40](https://github.com/user-attachments/assets/f80f152b-cbbb-4e96-b2f5-b1ab6da27e44)


> **Note:** These are example screenshots. Your simulator/device may show different currency or date formats based on your locale.

---

## Features

1. **Expense List**

   * Displays all expenses, sorted by date (newest first).
   * Each row shows a title, formatted date, and amount (localized currency).
   * Data is persisted locally with SwiftData, so your expenses remain after closing the app.

2. **Add Expense Sheet**

   * Tap the “＋” button in the navigation bar to open a modal sheet.
   * Enter a **Title**, **Amount** (decimal keyboard), and **Date** (DatePicker).
   * The “Save” button is enabled only when the form is valid (non-empty title and a parseable amount).
   * On save, the new `Expense` is inserted into the SwiftData context and saved immediately; the list auto-updates.

3. **7-Day Spending Chart**

   * Switch to the “Chart” tab to view a bar chart of your last 7 days’ spending.
   * Chart is built with Swift Charts, grouping expenses by day.
   * X-axis labels use abbreviated weekday names (Mon, Tue, Wed, etc.), and the Y-axis shows dollar amounts.
   * As you add expenses, the chart updates automatically.

4. **Sample Data on First Launch**

   * If no expenses exist, a sample expense (“Coffee – \$3.75”) is inserted automatically on first launch, allowing you to see how the list and chart work without typing data manually.

---

## Prerequisites

* **Xcode 15.5** (or later)
* **iOS 17.0 SDK** (simulator or device)
* **Swift 5.9+**
* A **free Apple ID**

> The project uses Apple’s new SwiftData APIs, which require iOS 17+.

---

## Installation & Setup

1. **Clone the Repository**

   ```bash
   git clone https://github.com/matboone/FinanceTracker.git
   cd FinanceTracker
   ```

2. **Open in Xcode**

   ```bash
   open FinanceTracker.xcodeproj
   ```

   * If Xcode warns about missing dependencies or an older Swift version, choose “Update to recommended settings.”

3. **Select an iOS Simulator or Device**

   * In Xcode’s toolbar, choose an iPhone running iOS 17 (e.g., “iPhone 15 Pro”) from the Scheme dropdown.

4. **Build & Run**

   * Press **⌘B** to build, then **⌘R** to run.
   * The app will launch in the simulator or on your device.

That’s it! You now have a working copy of FinanceTracker.

---

## Project Structure

```
FinanceTracker/
├── FinanceTracker.xcodeproj        # Xcode project file
├── FinanceTracker/                 # Main app folder
│   ├── Assets.xcassets             # App icons, asset catalogs
│   ├── Expense.swift               # @Model definition for Expense
│   ├── ContentView.swift           # Main tabbed view (List + Chart)
│   ├── AddExpenseView.swift        # Form sheet for adding new expenses
│   ├── ExpenseChartView.swift      # Swift Charts bar chart of last 7 days
│   ├── FinanceTrackerApp.swift     # @main app entry point (ModelContainer setup)
│   └── Info.plist
├── FinanceTrackerTests/            # Unit tests target (if any)
│   └── FinanceTrackerTests.swift
├── FinanceTrackerUITests/          # UI tests target (if any)
│   └── FinanceTrackerUITests.swift
├── .gitignore                      # Common Swift/Xcode ignores
├── LICENSE                         # MIT License (or your chosen license)
└── README.md                       # ← (this file)
```

* **Expense.swift**

  ```swift
  import Foundation
  import SwiftData

  @Model
  final class Expense: Identifiable {
      @Attribute(.unique) var id: UUID
      var title: String
      var amount: Double
      var date: Date

      init(title: String, amount: Double, date: Date = Date()) {
          self.id = UUID()
          self.title = title
          self.amount = amount
          self.date = date
      }
  }
  ```

* **ContentView\.swift**
  Implements a `TabView` with two tabs:

  1. **List Tab**: A `NavigationStack` showing `List(expenses)` powered by `@Query(sort: \.date, order: \.reverse)`
  2. **Chart Tab**: A `NavigationStack` showing `ExpenseChartView()` (Swift Charts).

* **AddExpenseView\.swift**
  A modal sheet with a `Form` to input a new expense:

  * Uses `@State` for `title`, `amount` (String), and `date`.
  * Validates form with a computed `formIsValid` Bool.
  * On “Save,” inserts a new `Expense` into `@Environment(\.modelContext)` and saves.

* **ExpenseChartView\.swift**

  * Query: `@Query(sort: \.date, order: \.forward) var allExpenses: [Expense]`
  * Computes an array `[ (day: Date, total: Double) ]` for the last 7 days by summing amounts.
  * Renders a `Chart { ForEach(last7DaysTotals) { BarMark(x: day, y: total) } }` with weekday labels.

* **FinanceTrackerApp.swift**

  * Configures a `ModelContainer` backed by a local SQLite store inside an App Group container.
  * Passes `.modelContainer(container)` into `ContentView()` so SwiftData is available throughout the app.

---

## How to Use

1. **Add an Expense**

   * Tap the “＋” button in the top-right corner of the “List” tab.
   * Fill in **Title** (e.g. “Coffee”), **Amount** (e.g. “4.50”), and **Date** (defaults to today).
   * Tap **Save**. The modal sheet dismisses, and the new expense appears at the top of the list.

2. **View Your Expenses**

   * In the **List** tab, scroll through your expense entries. Each row shows:

     * **Title** (bold)
     * **Formatted date** (e.g. “Jun 5 2025”) in a gray, small font
     * **Amount** with your locale’s currency code (e.g. “\$ 4.50”) on the right side.

3. **See a 7-Day Summary**

   * Tap the **Chart** tab (bar-chart icon) at the bottom.
   * The bar chart shows spending totals for each of the last 7 days.
   * Bars labeled “Mon”, “Tue”, “Wed”, etc., with heights corresponding to sums of expenses on that day.

4. **Sample Data**

   * On first launch (if no expenses exist), FinanceTracker automatically inserts a sample “Coffee – \$3.75” entry so you can see how the list and chart behave.

---

## Tech Stack & Dependencies

* **Swift 5.9+**
* **Xcode 15.5+**
* **iOS 17.0+**
* **SwiftUI** (all user interfaces built declaratively)
* **SwiftData** (Apple’s new persistence framework replacing Core Data)

  * `@Model Expense`
  * `@Query` to fetch `Expense` objects in real time
  * `ModelContainer` backed by a local SQLite file in App Group.
* **Swift Charts**

  * `Chart { BarMark(...) }` for the 7-day spending summary.

*No third-party dependencies or package managers are required—everything uses Apple’s built-in frameworks.*

---

## License

This project is open-source and released under the [MIT License](LICENSE). See `LICENSE` for full details.

---

Thank you for checking out **FinanceTracker**!
Feel free to open issues or submit pull requests if you have suggestions or improvements. If you’d like to test on a physical device, make sure Xcode is signed in with your Apple ID (a free account is sufficient). Enjoy tracking your spending!
