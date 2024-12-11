//
//  StikSourceView.swift
//  StikSource
//
//  Created by Stephen on 12/11/24.
//

import SwiftUI

public struct StikSourceView: View {
    @StateObject private var manager = StikSourceManager()
    @State private var isLoading = false

    let sourceURL: String

    public init(sourceURL: String) {
        self.sourceURL = sourceURL
    }

    public var body: some View {
        NavigationView {
            Group {
                if isLoading {
                    ProgressView("Loading...")
                        .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                        .scaleEffect(1.5)
                } else if let source = manager.source {
                    List {
                        Section(header: Text(source.name)
                            .font(.largeTitle)
                            .bold()
                            .padding(.vertical, 5)) {
                            ForEach(source.apps) { app in
                                NavigationLink(destination: AppDetailView(app: app)) {
                                    AppRowView(app: app)
                                }
                                .listRowBackground(backgroundColor)
                            }
                        }
                    }
                } else {
                    Text("No data available.")
                        .foregroundColor(.secondary)
                        .font(.headline)
                }
            }
            .task {
                await fetchData()
            }
            .navigationTitle("Apps")
        }
    }

    private func fetchData() async {
        isLoading = true
        do {
            try await manager.fetchSource(from: sourceURL)
        } catch {
            print("Error: \(error.localizedDescription)")
        }
        isLoading = false
    }

    // Pure SwiftUI Background Color
    private var backgroundColor: Color {
        Color.gray.opacity(0.1)
    }
}

// MARK: - App Row View
struct AppRowView: View {
    let app: App

    var body: some View {
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
