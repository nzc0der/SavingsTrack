import SwiftUI

struct DashboardView: View {
    @ObservedObject var viewModel: SavingsViewModel
    @State private var selectedTimeframe = "This Month"

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 32) {

                // Header
                HStack(alignment: .center) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Good Day, Investor")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.secondary)

                        Text("Overview")
                            .font(.system(size: 34, weight: .bold, design: .rounded))
                    }

                    Spacer()

                    Picker("", selection: $selectedTimeframe) {
                        Text("This Month").tag("This Month")
                        Text("This Quarter").tag("This Quarter")
                        Text("This Year").tag("This Year")
                    }
                    .pickerStyle(.segmented)
                    .frame(width: 250)
                }

                // Main Balance Card
                MainBalanceCard(balance: viewModel.currentBalance)

                // Stats
                LazyVGrid(
                    columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ],
                    spacing: 20
                ) {
                    StatCard(
                        title: "Income",
                        amount: viewModel.totalIncome,
                        icon: "arrow.down.left.circle.fill",
                        color: .green
                    )

                    StatCard(
                        title: "Expenses",
                        amount: viewModel.totalExpenses,
                        icon: "arrow.up.right.circle.fill",
                        color: .red
                    )
                }

                // Goals
                VStack(alignment: .leading, spacing: 16) {

                    HStack {
                        Text("Savings Goals")
                            .font(.title2)
                            .fontWeight(.bold)

                        Spacer()

                        Button("View All") { }
                            .buttonStyle(.plain)
                            .foregroundColor(.blue)
                    }

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 20) {

                            if viewModel.goals.isEmpty {

                                Text("No goals set yet")
                                    .foregroundColor(.secondary)
                                    .frame(width: 200, height: 120)
                                    .background(
                                        Color.primary.opacity(0.05)
                                    )
                                    .cornerRadius(16)

                            } else {

                                ForEach(viewModel.goals) { goal in
                                    GoalCard(goal: goal)
                                }

                            }
                        }
                    }
                }

                // Transactions
                VStack(alignment: .leading, spacing: 16) {

                    Text("Recent Transactions")
                        .font(.title2)
                        .fontWeight(.bold)

                    VStack(spacing: 0) {

                        if viewModel.transactions.isEmpty {

                            Text("No recent activity")
                                .padding()
                                .foregroundColor(.secondary)

                        } else {

                            let sortedTransactions = viewModel.transactions
                                .sorted(by: { $0.date > $1.date })

                            ForEach(Array(sortedTransactions.prefix(5))) { transaction in

                                TransactionRow(transaction: transaction)

                                if transaction.id != sortedTransactions.prefix(5).last?.id {
                                    Divider()
                                        .padding(.horizontal)
                                }
                            }
                        }
                    }
                    .background(Color(NSColor.controlBackgroundColor))
                    .cornerRadius(16)
                }
            }
            .padding(40)
        }
        .background(Color(NSColor.windowBackgroundColor))
    }
}

struct MainBalanceCard: View {

    let balance: Double

    var body: some View {

        VStack(spacing: 8) {

            Text("Total Balance")
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.white.opacity(0.8))

            Text("$\(balance, specifier: "%.2f")")
                .font(
                    .system(
                        size: 48,
                        weight: .bold,
                        design: .rounded
                    )
                )
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(
                    LinearGradient(
                        colors: [
                            Color.blue,
                            Color(
                                red: 0.2,
                                green: 0.1,
                                blue: 0.5
                            )
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        )
        .shadow(
            color: Color.blue.opacity(0.3),
            radius: 20,
            x: 0,
            y: 10
        )
    }
}

struct StatCard: View {

    let title: String
    let amount: Double
    let icon: String
    let color: Color

    var body: some View {

        HStack(spacing: 16) {

            Image(systemName: icon)
                .font(.title)
                .foregroundColor(color)
                .frame(width: 50, height: 50)
                .background(color.opacity(0.1))
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 2) {

                Text(title)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.secondary)
                    .textCase(.uppercase)

                Text("$\(amount, specifier: "%.2f")")
                    .font(.title2)
                    .fontWeight(.bold)
            }

            Spacer()
        }
        .padding()
        .background(Color(NSColor.controlBackgroundColor))
        .cornerRadius(20)
        .shadow(
            color: Color.black.opacity(0.03),
            radius: 10,
            x: 0,
            y: 5
        )
    }
}

struct GoalCard: View {

    let goal: Goal

    var body: some View {

        VStack(alignment: .leading, spacing: 12) {

            Text(goal.title)
                .font(.headline)

            Spacer()

            VStack(alignment: .leading, spacing: 6) {

                HStack {

                    Text("\(Int(goal.progress * 100))%")
                        .font(.caption)
                        .fontWeight(.bold)

                    Spacer()

                    Text("$\(goal.targetAmount, specifier: "%.0f")")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                ProgressView(value: goal.progress)
                    .accentColor(.blue)
                    .scaleEffect(
                        x: 1,
                        y: 1.5,
                        anchor: .center
                    )
            }
        }
        .padding()
        .frame(width: 200, height: 120)
        .background(Color(NSColor.controlBackgroundColor))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(
                    Color.primary.opacity(0.05),
                    lineWidth: 1
                )
        )
    }
}
