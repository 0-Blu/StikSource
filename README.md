# StikSource

**StikSource** is a Swift Package for fetching and decoding **AltStore-compatible JSON source data** from a given URL. It provides a simple API and SwiftUI views to display the decoded data in your app.

## Features

- Fetches and decodes AltStore source JSON.
- Provides a SwiftUI-friendly way to display the source content.
- Compatible with **iOS 15+** and **macOS 12+**.

---

## Installation

### Using Swift Package Manager (SPM)

1. Open your Xcode project.
2. Go to **File > Add Packages...**.
3. Enter the repository URL:
   ```
   https://github.com/0-Blu/StikSource.git
   ```
4. Add the **StikSource** package to your project.

---

## Sample Usage

### SwiftUI Example

Here’s an example of how you can use **StikSource** to fetch and display data from a source URL.

```swift
import SwiftUI
import StikSource

struct ContentView: View {
    var body: some View {
        StikSourceView(sourceURL: "https://quarksources.github.io/altstore-complete.json")
    }
}

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
```

### Output
This will fetch the data from the provided URL and display:

- **Source Name**
- **List of Apps** with icons, names, and developer information.

---

## SwiftUI `StikSourceView`

`StikSourceView` is a prebuilt SwiftUI view to display the fetched AltStore source data.

### Parameters

| Parameter     | Type         | Description                          |
|---------------|--------------|--------------------------------------|
| `sourceURL`   | `String`     | The URL of the AltStore JSON source. |

---

## Manual Fetching

If you want more control, you can fetch and decode the source data manually using `StikSourceManager`.

### Example

```swift
import SwiftUI
import StikSource

struct ManualFetchView: View {
    @StateObject private var manager = StikSourceManager()
    @State private var isLoading = false

    let sourceURL = "https://quarksources.github.io/altstore-complete.json"

    var body: some View {
        VStack {
            if isLoading {
                ProgressView("Loading...")
            } else if let source = manager.source {
                Text(source.name)
                    .font(.largeTitle)
                    .padding()

                List(source.apps) { app in
                    HStack {
                        AsyncImage(url: URL(string: app.iconURL)) { image in
                            image.resizable()
                        } placeholder: {
                            Color.gray.opacity(0.3)
                        }
                        .frame(width: 50, height: 50)
                        .cornerRadius(10)

                        VStack(alignment: .leading) {
                            Text(app.name).font(.headline)
                            Text(app.developerName)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                }
            } else {
                Text("No data available.")
            }
        }
        .task {
            isLoading = true
            do {
                try await manager.fetchSource(from: sourceURL)
                isLoading = false
            } catch {
                print("Failed to fetch data: \(error.localizedDescription)")
                isLoading = false
            }
        }
    }
}
```

---

## Testing

Run the included test suite to verify the package functionality:

```bash
swift test
```

### Test File: `StikSourceTests.swift`

The test suite verifies:
- Successful fetching of source JSON.
- Correct decoding of source and app data.

---

## Requirements

- **iOS 15+**
- **macOS 12+**
- Swift 5.5+

---

## License

This package is licensed under the **MIT License**.  
Feel free to use and modify it for your projects.

---

## Author

**0-Blu**  
[GitHub Profile](https://github.com/0-Blu)

---

### Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change. 🚀
