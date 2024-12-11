// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

// MARK: - Source Model
public struct Source: Codable {
    public let name: String
    public let subtitle: String?
    public let description: String?
    public let iconURL: URL?
    public let headerURL: URL?
    public let website: URL?
    public let tintColor: String?
    public let featuredApps: [String]?
    public let apps: [App]
    public let news: [News]?
}

// MARK: - App Model
public struct App: Codable {
    public let name: String
    public let bundleIdentifier: String
    public let developerName: String
    public let subtitle: String?
    public let localizedDescription: String
    public let iconURL: URL?
    public let tintColor: String?
    public let screenshots: [ScreenshotType]?
    public let versions: [AppVersion]
    public let appPermissions: AppPermissions?
}

// MARK: - Screenshot Type
public enum ScreenshotType: Codable {
    case url(URL)
    case detailed(ImageDetails)

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let url = try? container.decode(URL.self) {
            self = .url(url)
        } else {
            let details = try container.decode(ImageDetails.self)
            self = .detailed(details)
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .url(let url):
            try container.encode(url)
        case .detailed(let details):
            try container.encode(details)
        }
    }
}

// MARK: - Image Details
public struct ImageDetails: Codable {
    public let imageURL: URL
    public let width: Int
    public let height: Int
}

// MARK: - App Version
public struct AppVersion: Codable {
    public let version: String
    public let date: String
    public let downloadURL: URL
    public let localizedDescription: String
    public let size: Int
    public let minOSVersion: String?
    public let maxOSVersion: String?
}

// MARK: - App Permissions
public struct AppPermissions: Codable {
    public let entitlements: [String]?
    public let privacy: [String: String]?
}

// MARK: - News
public struct News: Codable {
    public let title: String
    public let identifier: String
    public let caption: String
    public let date: String
    public let tintColor: String?
    public let imageURL: URL?
    public let notify: Bool
    public let url: URL?
    public let appID: String?
}

// MARK: - Network Loader
public class StikSourceLoader {
    public static func fetchSource(from url: URL, completion: @escaping (Result<Source, Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "No Data", code: 0, userInfo: nil)))
                return
            }
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let source = try decoder.decode(Source.self, from: data)
                completion(.success(source))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
