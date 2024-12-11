# **StikSource**

StikSource is a Swift package designed to decode and display **AltStore-compatible sources** from remote URLs. It parses AltStore 2.0 JSON source files and allows you to interact with the data using SwiftUI.

---

## **Features**
- Fetches AltStore 2.0 source JSON from any URL.
- Decodes all source fields, including apps, versions, permissions, and news.
- Provides an easy-to-use SwiftUI interface to display the source details.

---

## **Installation**

1. Open your Xcode project.
2. Go to **File > Add Packages**.
3. Enter the following URL for the Swift Package:
   ```
   https://github.com/0-Blu/StikSource.git
   ```
4. Add the `StikSource` dependency to your desired target.

---

## **Usage**

Here’s an example of fetching and displaying AltStore source data in SwiftUI.

### **1. Import StikSource**
First, import the package:

```swift
import StikSource
import SwiftUI
```

---

### **2. Fetch Source JSON and Display Data**

This example fetches the source from a URL and displays key details:

```swift
import SwiftUI
import StikSource

struct ContentView: View {
    @State private var source: Source?
    @State private var errorMessage: String?
    
    var body: some View {
        NavigationView {
            VStack {
                if let source = source {
                    List {
                        // Source Details
                        Section(header: Text("Source Details")) {
                            Text("Name: \(source.name)")
                            if let subtitle = source.subtitle {
                                Text("Subtitle: \(subtitle)")
                            }
                            if let description = source.description {
                                Text(description)
                            }
                        }
                        
                        // Apps List
                        Section(header: Text("Apps")) {
                            ForEach(source.apps, id: \.bundleIdentifier) { app in
                                VStack(alignment: .leading) {
                                    Text(app.name)
                                        .font(.headline)
                                    Text(app.localizedDescription)
                                        .font(.subheadline)
                                }
                                .padding(5)
                            }
                        }
                    }
                } else if let errorMessage = errorMessage {
                    // Display error if loading fails
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                } else {
                    // Loading indicator
                    ProgressView("Loading Source...")
                }
            }
            .onAppear(perform: loadSource)
            .navigationTitle("StikSource Example")
        }
    }

    // Fetch the AltStore source JSON
    private func loadSource() {
        guard let url = URL(string: "https://altstore.oatmealdome.me") else {
            errorMessage = "Invalid URL"
            return
        }
        
        StikSourceLoader.fetchSource(from: url) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let loadedSource):
                    self.source = loadedSource
                case .failure(let error):
                    self.errorMessage = "Failed to load source: \(error.localizedDescription)"
                }
            }
        }
    }
}
```

---

### **3. Display the SwiftUI View**
Set `ContentView` as your app’s entry point:

```swift
@main
struct StikSourceExampleApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
```

---

## **Screenshot**

When the above example runs, it will display:
- **Source Details**: Name, subtitle, and description.
- **Apps**: A list of apps with their names and descriptions.

---

## **Sample JSON for Testing**

To test locally, you can use this sample JSON:

```json
{
    "name": "Example Source",
    "subtitle": "All my apps in one place.",
    "description": "Welcome to my AltStore source!",
    "apps": [
        {
            "name": "My Example App",
            "bundleIdentifier": "com.example.myapp",
            "localizedDescription": "This is an awesome app.",
            "versions": [
                {
                    "version": "1.0",
                    "downloadURL": "https://example.com/myapp.ipa",
                    "size": 10000000
                }
            ]
        }
    ]
}
```

---

## **Requirements**
- **iOS 13+** / **macOS 10.15+**
- Swift Package Manager

---

## **License**
This project is licensed under the **MIT License**. See the [LICENSE](LICENSE) file for more details.

---

## **Credits**
Built by **0-Blu**.
