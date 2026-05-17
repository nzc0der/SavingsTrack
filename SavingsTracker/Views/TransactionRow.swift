import SwiftUI

struct TransactionRow: View {
    let transaction: Transaction

    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(transaction.type == .income ? Color.green.opacity(0.1) : Color.red.opacity(0.1))
                    .frame(width: 40, height: 40)

                Image(systemName: transaction.type == .income ? "arrow.down.left" : "arrow.up.right")
                    .font(.system(size: 16, weight: .bold))
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
