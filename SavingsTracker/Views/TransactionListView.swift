import SwiftUI

struct TransactionListView: View {
    @ObservedObject var viewModel: SavingsViewModel
    @State private var showingAddTransaction = false
    @State private var searchText = ""

    var filteredTransactions: [Transaction] {
        if searchText.isEmpty {
            return viewModel.transactions.sorted(by: { $0.date > $1.date })
        } else {
            return viewModel.transactions.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
                .sorted(by: { $0.date > $1.date })
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            List {
                ForEach(filteredTransactions) { transaction in
                    TransactionRow(transaction: transaction)
                        .listRowInsets(EdgeInsets())
                        .listRowBackground(Color.clear)
                        .padding(.horizontal)
                        .padding(.vertical, 4)
                        .background(Color(NSColor.controlBackgroundColor))
                        .cornerRadius(10)
                        .padding(.vertical, 4)
                        .padding(.horizontal)
                }
                .onDelete(perform: deleteTransactions)
            }
            .listStyle(PlainListStyle())
        }
        .navigationTitle("Transactions")
        .searchable(text: $searchText, prompt: "Search transactions...")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: { showingAddTransaction.toggle() }) {
                    Label("Add Transaction", systemImage: "plus")
                }
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
