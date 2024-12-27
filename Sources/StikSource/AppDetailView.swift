//
//  AppDetailView.swift
//  StikSource
//
//  Created by Stephen on 12/11/24.
//

import SwiftUI

public struct AppDetailView: View {
    public let app: App
    @State private var isDownloading = false
    @State private var downloadProgress: Double = 0
    @State private var downloadCompleted = false

    public init(app: App) {
        self.app = app
    }

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // App Icon
                AsyncImage(url: URL(string: app.iconURL)) { image in
                    image.resizable()
                        .scaledToFit()
                } placeholder: {
                    Color.gray.opacity(0.3)
                }
                .frame(width: 120, height: 120)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .shadow(radius: 5)
                .padding(.horizontal)

                // App Title & Developer
                VStack(alignment: .leading, spacing: 10) {
                    Text(app.name)
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    Text("by \(app.developerName)")
                        .font(.title2)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)

                Divider()

                // App Description
                VStack(alignment: .leading, spacing: 10) {
                    Text("Description")
                        .font(.headline)

                    Text(app.localizedDescription)
                        .font(.body)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)
                }
                .padding(.horizontal)

                // Screenshots
                if let screenshots = app.screenshotURLs, !screenshots.isEmpty {
                    Divider()
                    Text("Screenshots")
                        .font(.headline)
                        .padding(.horizontal)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(screenshots, id: \.self) { url in
                                AsyncImage(url: URL(string: url)) { image in
                                    image.resizable()
                                        .scaledToFill()
                                        .frame(width: 200, height: 400)
                                        .clipped()
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                        .shadow(radius: 4)
                                } placeholder: {
                                    Color.gray.opacity(0.3)
                                        .frame(width: 200, height: 400)
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }

                // IPA Download Button
                Divider()
                if isDownloading {
                    ProgressView(value: downloadProgress)
                        .padding(.horizontal)
                } else {
                    Button(action: {
                        downloadIPA()
                    }) {
                        Text("Download IPA")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(hex: app.tintColor ?? "#007BFF"))
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .shadow(radius: 4)
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.bottom, 20)
        }
        .navigationTitle(app.name)
        .background(Color(hex: app.tintColor ?? "#F0F0F0").opacity(0.1))
        .alert(isPresented: $downloadCompleted) {
            Alert(title: Text("Download Complete"), message: Text("The IPA file has been downloaded."), dismissButton: .default(Text("OK")))
        }
    }

    private func downloadIPA() {
        guard let ipaURL = URL(string: app.ipaURL) else { return }
        isDownloading = true

        let task = URLSession.shared.downloadTask(with: ipaURL) { location, response, error in
            DispatchQueue.main.async {
                isDownloading = false
                if let location = location, error == nil {
                    saveDownloadedFile(from: location)
                    downloadCompleted = true
                } else {
                    // Handle errors appropriately
                    print("Download failed: \(error?.localizedDescription ?? "Unknown error")")
                }
            }
        }

        task.resume()
    }

    private func saveDownloadedFile(from location: URL) {
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!

        let destinationURL = documentsURL.appendingPathComponent(app.name + ".ipa")
        try? fileManager.removeItem(at: destinationURL) // Remove existing file if it exists
        do {
            try fileManager.copyItem(at: location, to: destinationURL)
            print("File saved to: \(destinationURL)")
        } catch {
            print("File save error: \(error.localizedDescription)")
        }
    }
}

// MARK: - App Model Example
public struct App {
    let name: String
    let developerName: String
    let iconURL: String
    let localizedDescription: String
    let screenshotURLs: [String]?
    let tintColor: String?
    let ipaURL: String // Add this property for the IPA download link
}

// MARK: - Color Extension for Hex Colors
extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex.replacingOccurrences(of: "#", with: ""))
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        let red = Double((rgb >> 16) & 0xFF) / 255.0
        let green = Double((rgb >> 8) & 0xFF) / 255.0
        let blue = Double(rgb & 0xFF) / 255.0
        self.init(red: red, green: green, blue: blue)
    }
}
