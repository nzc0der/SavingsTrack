import Foundation

enum TransactionType: String, Codable, CaseIterable {
    case income = "Income"
    case expense = "Expense"
}

struct Transaction: Identifiable, Codable {
    var id = UUID()
    var title: String
    var amount: Double
    var date: Date
    var type: TransactionType
}
