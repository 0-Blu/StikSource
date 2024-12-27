//
//  AppDetailView.swift
//  StikSource
//
//  Created by Stephen on 12/11/24.
//

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

                // IPA Download Button
                if let downloadURL = app.versions.first?.downloadURL {
                    Divider()
                    Button(action: {
                        if let url = URL(string: downloadURL) {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        HStack {
                            Spacer()
                            Text("Download IPA")
                                .font(.headline)
                                .padding()
                                .foregroundColor(.white)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.accentColor)
                                )
                            Spacer()
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.bottom, 20)
        }
        .navigationTitle(app.name)
        .background(app.tintColor.map { Color(hex: $0).opacity(0.2) } ?? Color.gray.opacity(0.1))
    }
}
