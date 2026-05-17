import SwiftUI

struct AddGoalView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: SavingsViewModel

    @State private var title = ""
    @State private var targetAmount = ""
    @State private var hasDeadline = false
    @State private var deadline = Date()

    var body: some View {
        VStack(spacing: 20) {
            Text("New Goal")
                .font(.headline)

            Form {
                TextField("Title", text: $title)
                TextField("Target Amount", text: $targetAmount)

                Toggle("Add Deadline", isOn: $hasDeadline)
                if hasDeadline {
                    DatePicker("Deadline", selection: $deadline, displayedComponents: .date)
                }
            }

            HStack {
                Button("Cancel") {
                    dismiss()
                }
                Spacer()
                Button("Save") {
                    if let amountDouble = Double(targetAmount) {
                        viewModel.addGoal(title: title, targetAmount: amountDouble, deadline: hasDeadline ? deadline : nil)
                        dismiss()
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(title.isEmpty || targetAmount.isEmpty)
            }
        }
        .padding()
        .frame(width: 400, height: 300)
    }
}
