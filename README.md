# Savings Tracker for macOS

A sleek, native macOS application built with SwiftUI to help you track your finances and reach your savings goals.

## Features

- **Dashboard Overview**: Instantly see your current balance, total income, and total expenses.
- **Transaction History**: Keep a detailed log of every dollar coming in and going out.
- **Goal Tracking**: Set specific savings goals with target amounts and deadlines. Track your progress with visual progress bars.
- **Menu Bar Integration**: Monitor your current balance directly from the macOS menu bar without opening the main app window.
- **Native Look & Feel**: Designed specifically for macOS with a clean sidebar-based navigation.
- **Automatic Persistence**: Your data is automatically saved and loaded.

## Prerequisites

- **macOS 13.0** (Ventura) or later.
- **Swift 5.9** or later.

## Installation and Usage

### Option 1: Going to the releases tab and downloading from there.


### Option 2: Using Xcode (Recommended for devs)

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/nzc0der/SavingsTrack.git
   cd SavingsTrack
   ```
2. **Open the Project**:
   Double-click the `SavingsTrack` folder or use `open .` and Xcode should recognize the Swift Package. Alternatively, if you've created an `.xcodeproj`, open that.
3. **Select Target**:
   Ensure the `SavingsTracker` scheme is selected in the top bar.
4. **Run**:
   Press `Cmd + R` to build and run the application.

### Option 3: Without Xcode (Command Line)

If you have the Swift toolchain installed (comes with Xcode Command Line Tools), you can build and run using the Swift Package Manager.

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/nzc0der/SavingsTrack.git
   cd SavingsTrack
   ```
2. **Build the Project**:
   ```bash
   swift build -c release
   ```
3. **Run the Application**:
   ```bash
   ./.build/release/SavingsTracker
   ```

## Project Structure

- `SavingsTracker/`: Main application source code.
  - `Models/`: Data structures for Transactions and Goals.
  - `ViewModels/`: Business logic and data persistence.
  - `Views/`: SwiftUI views for the dashboard, lists, and forms.
  - `SavingsTrackerApp.swift`: The entry point of the app and Menu Bar logic.
- `SavingsTrackerTests/`: Unit tests for ensuring logic accuracy.
- `Package.swift`: Swift Package Manager configuration.

## Development

### Running Tests

You can run the included unit tests via Xcode (`Cmd + U`) or via the command line:
```bash
swift test
```

## License

This project is open-source and available under the MIT License.
