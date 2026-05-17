import SwiftUI

struct GoalListView: View {
    @ObservedObject var viewModel: SavingsViewModel
    @State private var showingAddGoal = false
    @State private var selectedGoal: Goal?
    @State private var contributionAmount: String = ""

    var body: some View {
        List {
            ForEach(viewModel.goals) { goal in
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(goal.title)
                            .font(.headline)
                        Spacer()
                        Text("$\(goal.targetAmount, specifier: "%.2f")")
                            .foregroundColor(.secondary)
                    }

                    ProgressView(value: goal.progress)

                    HStack {
                        Text("\(Int(goal.progress * 100))% complete")
                            .font(.caption)
                        Spacer()
                        Button("Add Funds") {
                            selectedGoal = goal
                        }
                        .buttonStyle(.borderless)
                        .foregroundColor(.blue)
                    }
                }
                .padding(.vertical, 8)
            }
            .onDelete(perform: deleteGoals)
        }
        .navigationTitle("Goals")
        .toolbar {
            Button(action: { showingAddGoal.toggle() }) {
                Image(systemName: "plus")
            }
        }
        .sheet(isPresented: $showingAddGoal) {
            AddGoalView(viewModel: viewModel)
        }
        .sheet(item: $selectedGoal) { goal in
            VStack(spacing: 20) {
                Text("Add Funds to \(goal.title)")
                    .font(.headline)

                TextField("Amount", text: $contributionAmount)
                    .textFieldStyle(.roundedBorder)

                HStack {
                    Button("Cancel") {
                        selectedGoal = nil
                        contributionAmount = ""
                    }
                    Spacer()
                    Button("Add") {
                        if let amount = Double(contributionAmount) {
                            viewModel.updateGoalProgress(goalId: goal.id, amount: amount)
                        }
                        selectedGoal = nil
                        contributionAmount = ""
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .padding()
            .frame(width: 300)
        }
    }

    private func deleteGoals(at offsets: IndexSet) {
        viewModel.goals.remove(atOffsets: offsets)
    }
}
