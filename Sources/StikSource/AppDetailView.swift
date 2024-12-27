//
//  AppDetailView.swift
//  StikSource
//
//  Created by Stephen on 12/11/24.
//

import SwiftUI

public struct AppDetailView: View {
    public let app: App

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

                // Tint Color (Visual)
                if let tintColor = app.tintColor {
                    Divider()
                    HStack {
                        Text("Tint Color")
                            .font(.headline)

                        Spacer()

                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(hex: tintColor))
                            .frame(width: 30, height: 30)
                            .shadow(radius: 3)
                    }
                    .padding(.horizontal)
                }
<<<<<<< HEAD
<<<<<<< HEAD

                // IPA Download Button
                if let ipaURL = app.ipaURL, let url = URL(string: ipaURL) {
                    Divider()
                    Button(action: {
                        UIApplication.shared.open(url)
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
=======
>>>>>>> parent of c31261c (Update AppDetailView.swift)
=======
>>>>>>> parent of c31261c (Update AppDetailView.swift)
            }
            .padding(.bottom, 20)
        }
        .navigationTitle(app.name)
<<<<<<< HEAD
<<<<<<< HEAD
        .background(Color(hex: app.tintColor ?? "#F0F0F0").opacity(0.1))
=======
        .background(Color.gray.opacity(0.1))
>>>>>>> parent of c31261c (Update AppDetailView.swift)
=======
        .background(Color.gray.opacity(0.1))
>>>>>>> parent of c31261c (Update AppDetailView.swift)
    }
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
