import SwiftUI

struct DashboardView: View {
    @ObservedObject var viewModel: SavingsViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Dashboard")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                HStack(spacing: 15) {
                    SummaryCard(title: "Current Balance", amount: viewModel.currentBalance, color: .blue)
                    SummaryCard(title: "Income", amount: viewModel.totalIncome, color: .green)
                    SummaryCard(title: "Expenses", amount: viewModel.totalExpenses, color: .red)
                }

                VStack(alignment: .leading, spacing: 10) {
                    Text("Goal Progress")
                        .font(.headline)

                    if viewModel.goals.isEmpty {
                        Text("No goals set yet.")
                            .foregroundColor(.secondary)
                    } else {
                        ForEach(viewModel.goals) { goal in
                            VStack(alignment: .leading) {
                                HStack {
                                    Text(goal.title)
                                    Spacer()
                                    Text("$\(goal.currentAmount, specifier: "%.2f") / $\(goal.targetAmount, specifier: "%.2f")")
                                        .font(.caption)
                                }
                                ProgressView(value: goal.progress)
                            }
                            .padding(.vertical, 5)
                        }
                    }
                }
                .padding()
                .background(Color(NSColor.windowBackgroundColor))
                .cornerRadius(10)
            }
            .padding()
        }
    }
}

struct SummaryCard: View {
    let title: String
    let amount: Double
    let color: Color

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            Text("$\(amount, specifier: "%.2f")")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(color)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(NSColor.windowBackgroundColor))
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}
