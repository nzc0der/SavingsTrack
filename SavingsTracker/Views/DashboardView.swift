import SwiftUI

struct DashboardView: View {
    @ObservedObject var viewModel: SavingsViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 30) {
                headerSection

                HStack(spacing: 20) {
                    PremiumSummaryCard(
                        title: "Balance",
                        amount: viewModel.currentBalance,
                        icon: "creditcard.fill",
                        colors: [.blue, .purple]
                    )
                    PremiumSummaryCard(
                        title: "Monthly Income",
                        amount: viewModel.totalIncome,
                        icon: "arrow.down.circle.fill",
                        colors: [.green, .teal]
                    )
                    PremiumSummaryCard(
                        title: "Monthly Spent",
                        amount: viewModel.totalExpenses,
                        icon: "arrow.up.circle.fill",
                        colors: [.red, .orange]
                    )
                }

                goalsSection

                recentTransactionsSection
            }
            .padding(30)
        }
        .background(Color(NSColor.windowBackgroundColor).opacity(0.5))
    }

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Financial Overview")
                .font(.system(size: 34, weight: .bold, design: .rounded))
            Text(Date().formatted(date: .long, time: .omitted))
                .font(.title3)
                .foregroundColor(.secondary)
        }
    }

    private var goalsSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Savings Goals")
                .font(.title2)
                .fontWeight(.bold)

            if viewModel.goals.isEmpty {
                EmptyStateView(message: "No goals set. Start saving for something big!")
            } else {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 250))], spacing: 20) {
                    ForEach(viewModel.goals) { goal in
                        GoalProgressCard(goal: goal)
                    }
                }
            }
        }
    }

    private var recentTransactionsSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Recent Activity")
                .font(.title2)
                .fontWeight(.bold)

            VStack(spacing: 0) {
                if viewModel.transactions.isEmpty {
                    EmptyStateView(message: "No transactions yet.")
                } else {
                    ForEach(viewModel.transactions.sorted(by: { $0.date > $1.date }).prefix(5)) { transaction in
                        TransactionRow(transaction: transaction)
                        if transaction.id != viewModel.transactions.sorted(by: { $0.date > $1.date }).prefix(5).last?.id {
                            Divider().padding(.leading, 50)
                        }
                    }
                }
            }
            .background(Color(NSColor.controlBackgroundColor))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.primary.opacity(0.1), lineWidth: 1)
            )
        }
    }
}

struct PremiumSummaryCard: View {
    let title: String
    let amount: Double
    let icon: String
    let colors: [Color]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(.white)
                    .frame(width: 44, height: 44)
                    .background(LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing))
                    .clipShape(RoundedRectangle(cornerRadius: 12))

                Spacer()
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
                Text("$\(amount, specifier: "%.2f")")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(NSColor.controlBackgroundColor))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
    }
}

struct GoalProgressCard: View {
    let goal: Goal

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(goal.title)
                    .font(.headline)
                Spacer()
                Text("\(Int(goal.progress * 100))%")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
            }

            ProgressView(value: goal.progress)
                .tint(LinearGradient(colors: [.blue, .cyan], startPoint: .leading, endPoint: .trailing))

            HStack {
                Text("$\(goal.currentAmount, specifier: "%.0f") saved")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
                Text("Target: $\(goal.targetAmount, specifier: "%.0f")")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(NSColor.controlBackgroundColor))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.primary.opacity(0.05), lineWidth: 1)
        )
    }
}

struct TransactionRow: View {
    let transaction: Transaction

    var body: some View {
        HStack(spacing: 15) {
            ZStack {
                Circle()
                    .fill(transaction.type == .income ? Color.green.opacity(0.1) : Color.red.opacity(0.1))
                    .frame(width: 36, height: 36)

                Image(systemName: transaction.type == .income ? "arrow.down.left" : "arrow.up.right")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(transaction.type == .income ? .green : .red)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(transaction.title)
                    .font(.headline)
                Text(transaction.date, style: .date)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            Text("\(transaction.type == .income ? "+" : "-") $\(transaction.amount, specifier: "%.2f")")
                .font(.system(.body, design: .rounded))
                .fontWeight(.bold)
                .foregroundColor(transaction.type == .income ? .green : .primary)
        }
        .padding()
    }
}

struct EmptyStateView: View {
    let message: String

    var body: some View {
        HStack {
            Spacer()
            Text(message)
                .foregroundColor(.secondary)
                .italic()
            Spacer()
        }
        .padding()
        .background(Color.primary.opacity(0.03))
        .cornerRadius(12)
    }
}
