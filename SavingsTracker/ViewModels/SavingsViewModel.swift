import Foundation
import Combine

class SavingsViewModel: ObservableObject {
    @Published var transactions: [Transaction] = [] {
        didSet {
            saveTransactions()
        }
    }
    @Published var goals: [Goal] = [] {
        didSet {
            saveGoals()
        }
    }

    private let transactionsKey = "savings_transactions"
    private let goalsKey = "savings_goals"

    init() {
        loadTransactions()
        loadGoals()
    }

    var totalIncome: Double {
        transactions.filter { $0.type == .income }.reduce(0) { $0 + $1.amount }
    }

    var totalExpenses: Double {
        transactions.filter { $0.type == .expense }.reduce(0) { $0 + $1.amount }
    }

    var currentBalance: Double {
        totalIncome - totalExpenses
    }

    func addTransaction(title: String, amount: Double, type: TransactionType, date: Date = Date()) {
        let transaction = Transaction(title: title, amount: amount, date: date, type: type)
        transactions.append(transaction)
    }

    func addGoal(title: String, targetAmount: Double, deadline: Date? = nil) {
        let goal = Goal(title: title, targetAmount: targetAmount, currentAmount: 0, deadline: deadline)
        goals.append(goal)
    }

    func updateGoalProgress(goalId: UUID, amount: Double) {
        if let index = goals.firstIndex(where: { $0.id == goalId }) {
            goals[index].currentAmount += amount
        }
    }

    private func saveTransactions() {
        if let encoded = try? JSONEncoder().encode(transactions) {
            UserDefaults.standard.set(encoded, forKey: transactionsKey)
        }
    }

    private func loadTransactions() {
        if let data = UserDefaults.standard.data(forKey: transactionsKey),
           let decoded = try? JSONDecoder().decode([Transaction].self, from: data) {
            transactions = decoded
        }
    }

    private func saveGoals() {
        if let encoded = try? JSONEncoder().encode(goals) {
            UserDefaults.standard.set(encoded, forKey: goalsKey)
        }
    }

    private func loadGoals() {
        if let data = UserDefaults.standard.data(forKey: goalsKey),
           let decoded = try? JSONDecoder().decode([Goal].self, from: data) {
            goals = decoded
        }
    }
}
