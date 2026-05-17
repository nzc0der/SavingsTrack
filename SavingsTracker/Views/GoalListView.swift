import SwiftUI

struct GoalListView: View {
    @ObservedObject var viewModel: SavingsViewModel
    @State private var showingAddGoal = false
    @State private var selectedGoal: Goal?
    @State private var contributionAmount: String = ""

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                if viewModel.goals.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "target")
                            .font(.system(size: 60))
                            .foregroundColor(.secondary.opacity(0.5))
                        Text("No active goals")
                            .font(.title2)
                            .foregroundColor(.secondary)
                        Button("Create Your First Goal") {
                            showingAddGoal = true
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .frame(maxWidth: .infinity, minHeight: 400)
                } else {
                    ForEach(viewModel.goals) { goal in
                        DetailedGoalCard(goal: goal, viewModel: viewModel)
                    }
                }
            }
            .padding(30)
        }
        .navigationTitle("Savings Goals")
        .toolbar {
            Button(action: { showingAddGoal.toggle() }) {
                Label("Add Goal", systemImage: "plus")
            }
        }
        .sheet(isPresented: $showingAddGoal) {
            AddGoalView(viewModel: viewModel)
        }
    }
}

struct DetailedGoalCard: View {
    let goal: Goal
    @ObservedObject var viewModel: SavingsViewModel
    @State private var showingAddFunds = false
    @State private var amount = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(goal.title)
                        .font(.title2)
                        .fontWeight(.bold)
                    if let deadline = goal.deadline {
                        Text("Target Date: \(deadline.formatted(date: .abbreviated, time: .omitted))")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                Spacer()
                ZStack {
                    Circle()
                        .stroke(Color.primary.opacity(0.1), lineWidth: 8)
                        .frame(width: 70, height: 70)
                    Circle()
                        .trim(from: 0, to: goal.progress)
                        .stroke(LinearGradient(colors: [.blue, .purple], startPoint: .top, endPoint: .bottom), style: StrokeStyle(lineWidth: 8, lineCap: .round))
                        .frame(width: 70, height: 70)
                        .rotationEffect(.degrees(-90))

                    Text("\(Int(goal.progress * 100))%")
                        .font(.system(size: 14, weight: .bold))
                }
            }

            HStack(spacing: 40) {
                VStack(alignment: .leading) {
                    Text("Saved")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("$\(goal.currentAmount, specifier: "%.2f")")
                        .font(.title3)
                        .fontWeight(.bold)
                }

                VStack(alignment: .leading) {
                    Text("Remaining")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("$\(goal.remainingAmount, specifier: "%.2f")")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                }

                VStack(alignment: .leading) {
                    Text("Target")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("$\(goal.targetAmount, specifier: "%.2f")")
                        .font(.title3)
                        .fontWeight(.bold)
                }
            }

            HStack {
                Button(action: { showingAddFunds.toggle() }) {
                    Text("Add Funds")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                }
                .buttonStyle(.borderedProminent)

                Button(role: .destructive, action: {
                    if let index = viewModel.goals.firstIndex(where: { $0.id == goal.id }) {
                        viewModel.goals.remove(at: index)
                    }
                }) {
                    Image(systemName: "trash")
                        .padding(.vertical, 8)
                        .padding(.horizontal, 12)
                }
                .buttonStyle(.bordered)
            }
        }
        .padding(25)
        .background(Color(NSColor.controlBackgroundColor))
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.05), radius: 15, x: 0, y: 10)
        .sheet(isPresented: $showingAddFunds) {
            VStack(spacing: 20) {
                Text("Add Funds to \(goal.title)")
                    .font(.headline)

                TextField("Amount", text: $amount)
                    .textFieldStyle(.roundedBorder)

                HStack {
                    Button("Cancel") {
                        showingAddFunds = false
                        amount = ""
                    }
                    Spacer()
                    Button("Add") {
                        if let amountDouble = Double(amount) {
                            viewModel.updateGoalProgress(goalId: goal.id, amount: amountDouble)
                            showingAddFunds = false
                            amount = ""
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .padding()
            .frame(width: 300)
        }
    }
}
