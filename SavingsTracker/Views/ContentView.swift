import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: SavingsViewModel

    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: DashboardView(viewModel: viewModel)) {
                    Label("Dashboard", systemImage: "house")
                }
                NavigationLink(destination: TransactionListView(viewModel: viewModel)) {
                    Label("Transactions", systemImage: "list.bullet")
                }
                NavigationLink(destination: GoalListView(viewModel: viewModel)) {
                    Label("Goals", systemImage: "target")
                }
            }
            .listStyle(SidebarListStyle())
            .frame(minWidth: 200)

            DashboardView(viewModel: viewModel)
        }
        .frame(minWidth: 800, minHeight: 600)
    }
}
