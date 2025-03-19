//
//  StikSourceView.swift
//  StikSource
//
//  Created by Stephen on 12/11/24.
//

import SwiftUI
import UniformTypeIdentifiers

// MARK: - Models

public struct Source: Codable, Identifiable {
    public let id: UUID = UUID()
    public let name: String
    public let apps: [App]
    
    public init(name: String, apps: [App]) {
        self.name = name
        self.apps = apps
    }
}

public struct App: Codable, Identifiable {
    public let id: UUID = UUID()
    public let name: String
    public let developerName: String
    public let iconURL: String
    
    public init(name: String, developerName: String, iconURL: String) {
        self.name = name
        self.developerName = developerName
        self.iconURL = iconURL
    }
}

// MARK: - Detail & Row Views

public struct AppDetailView: View {
    public let app: App
    
    public init(app: App) {
        self.app = app
    }
    
    public var body: some View {
        VStack(spacing: 16) {
            Text(app.name)
                .font(.largeTitle)
                .bold()
            Text("Developed by \(app.developerName)")
                .font(.title2)
        }
        .padding()
    }
}

public struct AppRowView: View {
    public let app: App
    
    public init(app: App) {
        self.app = app
    }
    
    public var body: some View {
        HStack(spacing: 15) {
            AsyncImage(url: URL(string: app.iconURL)) { image in
                image.resizable()
                    .scaledToFit()
            } placeholder: {
                Color.gray.opacity(0.3)
            }
            .frame(width: 50, height: 50)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .shadow(radius: 4)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(app.name)
                    .font(.headline)
                Text(app.developerName)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 6)
    }
}

// MARK: - Main View for Uploading & Displaying Sources

public struct StikSourcesListView: View {
    @State private var sources: [Source] = []
    @State private var isFileImporterPresented = false
    @State private var isLoading = false

    public init() { }
    
    public var body: some View {
        NavigationView {
            Group {
                if isLoading {
                    ProgressView("Loading...")
                        .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                        .scaleEffect(1.5)
                } else if sources.isEmpty {
                    Text("No sources available.")
                        .foregroundColor(.secondary)
                        .font(.headline)
                } else {
                    List {
                        ForEach(sources) { source in
                            Section(header:
                                        Text(source.name)
                                        .font(.largeTitle)
                                        .bold()
                                        .padding(.vertical, 5)
                            ) {
                                ForEach(source.apps) { app in
                                    NavigationLink(destination: AppDetailView(app: app)) {
                                        AppRowView(app: app)
                                    }
                                    .listRowBackground(backgroundColor)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Uploaded Sources")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isFileImporterPresented = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .fileImporter(
                isPresented: $isFileImporterPresented,
                allowedContentTypes: [UTType.json],
                onCompletion: handleFileImport(result:)
            )
        }
    }
    
    // MARK: - Helper Methods
    
    private func handleFileImport(result: Result<URL, Error>) {
        switch result {
        case .success(let url):
            loadSource(from: url)
        case .failure(let error):
            print("Error importing file: \(error.localizedDescription)")
        }
    }
    
    private func loadSource(from url: URL) {
        isLoading = true
        defer { isLoading = false }
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let source = try decoder.decode(Source.self, from: data)
            sources.append(source)
        } catch {
            print("Error loading source: \(error.localizedDescription)")
        }
    }
    
    private var backgroundColor: Color {
        Color.gray.opacity(0.1)
    }
}

// MARK: - Previews

struct StikSourcesListView_Previews: PreviewProvider {
    static var previews: some View {
        StikSourcesListView()
    }
}
