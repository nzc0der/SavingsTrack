import SwiftUI

struct TransactionListView: View {
    @ObservedObject var viewModel: SavingsViewModel
    @State private var showingAddTransaction = false

    var body: some View {
        VStack {
            List {
                ForEach(viewModel.transactions.sorted(by: { $0.date > $1.date })) { transaction in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(transaction.title)
                                .font(.headline)
                            Text(transaction.date, style: .date)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        Text("\(transaction.type == .income ? "+" : "-") $\(transaction.amount, specifier: "%.2f")")
                            .foregroundColor(transaction.type == .income ? .green : .red)
                            .fontWeight(.semibold)
                    }
                }
                .onDelete(perform: deleteTransactions)
            }
        }
        .navigationTitle("Transactions")
        .toolbar {
            Button(action: { showingAddTransaction.toggle() }) {
                Image(systemName: "plus")
            }
        }
        .sheet(isPresented: $showingAddTransaction) {
            AddTransactionView(viewModel: viewModel)
        }
    }

    private func deleteTransactions(at offsets: IndexSet) {
        viewModel.transactions.remove(atOffsets: offsets)
    }
}
