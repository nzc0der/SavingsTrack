import SwiftUI

@main
struct SavingsTrackerApp: App {
    @StateObject private var viewModel = SavingsViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: viewModel)
        }
        .commands {
            SidebarCommands()
        }

        MenuBarExtra("Savings: $\(viewModel.currentBalance, specifier: "%.2f")", systemImage: "dollarsign.circle") {
            Text("Current Balance: $\(viewModel.currentBalance, specifier: "%.2f")")

            Divider()

            Button("Open Savings Tracker") {
                NSApp.activate(ignoringOtherApps: true)
            }

            Divider()

            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }
        }
        .menuBarExtraStyle(.menu)
    }
}
