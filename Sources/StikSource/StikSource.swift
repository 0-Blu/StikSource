// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

// MARK: - AltStore Source Model
public struct AltStoreSource: Codable {
    public let name: String
    public let identifier: String
    public let apiVersion: String?
    public let subtitle: String?
    public let description: String?
    public let iconURL: String?
    public let headerURL: String?
    public let website: String?
    public let tintColor: String?
    public let apps: [App]
    public let news: [News]?
}

// MARK: - App Model
public struct App: Codable, Identifiable {
    public var id: String { bundleIdentifier }
    public let name: String
    public let bundleIdentifier: String
    public let developerName: String
    public let localizedDescription: String
    public let iconURL: String
    public let tintColor: String?
    public let screenshotURLs: [String]?
    public let versions: [Version]
    public let appPermissions: AppPermissions?
}

// MARK: - Version Model
public struct Version: Codable {
    public let version: String
    public let date: String
    public let localizedDescription: String
    public let downloadURL: String
    public let size: Int
    public let sha256: String?
    public let minOSVersion: String?
}

// MARK: - App Permissions
public struct AppPermissions: Codable {
    public let entitlements: [String]?
    public let privacy: [Privacy]?
}

public struct Privacy: Codable {
    public let name: String
    public let usageDescription: String
}

// MARK: - News Model
public struct News: Codable, Identifiable {
    public var id: String { identifier }
    public let title: String
    public let identifier: String
    public let caption: String
    public let date: String
    public let imageURL: String?
    public let url: String?
}

// MARK: - Network Manager
public class StikSourceManager: ObservableObject {
    @Published public var source: AltStoreSource?

    public init() {}

    public func fetchSource(from urlString: String) async throws {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw URLError(.badServerResponse)
            }

            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase

            let decodedSource = try decoder.decode(AltStoreSource.self, from: data)
            DispatchQueue.main.async {
                self.source = decodedSource
            }
        } catch {
            print("Error fetching or decoding JSON: \(error.localizedDescription)")
            throw error
        }
    }
}
