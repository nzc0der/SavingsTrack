import SwiftUI

struct AddTransactionView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: SavingsViewModel

    @State private var title = ""
    @State private var amount = ""
    @State private var type: TransactionType = .expense
    @State private var date = Date()

    var body: some View {
        VStack(spacing: 20) {
            Text("New Transaction")
                .font(.headline)

            Form {
                TextField("Title", text: $title)
                TextField("Amount", text: $amount)
                Picker("Type", selection: $type) {
                    ForEach(TransactionType.allCases, id: \.self) { type in
                        Text(type.rawValue).tag(type)
                    }
                }
                DatePicker("Date", selection: $date, displayedComponents: .date)
            }

            HStack {
                Button("Cancel") {
                    dismiss()
                }
                Spacer()
                Button("Save") {
                    if let amountDouble = Double(amount) {
                        viewModel.addTransaction(title: title, amount: amountDouble, type: type, date: date)
                        dismiss()
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(title.isEmpty || amount.isEmpty)
            }
        }
        .padding()
        .frame(width: 400, height: 300)
    }
}
