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
            VStack {
                if isLoading {
                    ProgressView("Loading...")
                } else if let source = manager.source {
                    List {
                        Section(header: Text(source.name).font(.title)) {
                            ForEach(source.apps) { app in
                                HStack {
                                    AsyncImage(url: URL(string: app.iconURL)) { image in
                                        image.resizable().scaledToFit()
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
                        }
                    }
                } else {
                    Text("No data available.")
                }
            }
            .task {
                do {
                    isLoading = true
                    try await manager.fetchSource(from: sourceURL)
                    isLoading = false
                } catch {
                    print("Error: \(error.localizedDescription)")
                    isLoading = false
                }
            }
            .navigationTitle("StikSource")
        }
    }
}
