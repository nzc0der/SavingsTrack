import XCTest
@testable import SavingsTracker

final class SavingsViewModelTests: XCTestCase {
    var viewModel: SavingsViewModel!

    override func setUp() {
        super.setUp()
        viewModel = SavingsViewModel()
        // Clear data for testing
        viewModel.transactions = []
        viewModel.goals = []
    }

    func testInitialBalance() {
        XCTAssertEqual(viewModel.currentBalance, 0)
    }

    func testAddIncome() {
        viewModel.addTransaction(title: "Salary", amount: 1000, type: .income)
        XCTAssertEqual(viewModel.totalIncome, 1000)
        XCTAssertEqual(viewModel.currentBalance, 1000)
    }

    func testAddExpense() {
        viewModel.addTransaction(title: "Rent", amount: 500, type: .expense)
        XCTAssertEqual(viewModel.totalExpenses, 500)
        XCTAssertEqual(viewModel.currentBalance, -500)
    }

    func testNetBalance() {
        viewModel.addTransaction(title: "Salary", amount: 1000, type: .income)
        viewModel.addTransaction(title: "Rent", amount: 300, type: .expense)
        XCTAssertEqual(viewModel.currentBalance, 700)
    }

    func testGoalProgress() {
        viewModel.addGoal(title: "New Car", targetAmount: 10000)
        let goalId = viewModel.goals[0].id
        viewModel.updateGoalProgress(goalId: goalId, amount: 1000)
        XCTAssertEqual(viewModel.goals[0].currentAmount, 1000)
        XCTAssertEqual(viewModel.goals[0].progress, 0.1)
    }
}
