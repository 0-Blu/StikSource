//
//  AppDetailView.swift
//  StikSource
//
//  Created by Stephen on 12/11/24.
//


import SwiftUI

struct AppDetailView: View {
    let app: App

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                AsyncImage(url: URL(string: app.iconURL)) { image in
                    image.resizable().scaledToFit()
                } placeholder: {
                    Color.gray.opacity(0.3)
                }
                .frame(width: 120, height: 120)
                .cornerRadius(20)
                .padding()

                VStack(alignment: .leading, spacing: 10) {
                    Text(app.name)
                        .font(.largeTitle)
                        .bold()

                    Text("Developer: \(app.developerName)")
                        .font(.title2)
                        .foregroundColor(.secondary)

                    Divider()

                    Text("Description")
                        .font(.headline)
                    Text(app.localizedDescription)
                        .font(.body)

                    Divider()

                    if let screenshots = app.screenshotURLs {
                        Text("Screenshots")
                            .font(.headline)
                        ScrollView(.horizontal) {
                            HStack {
                                ForEach(screenshots, id: \.self) { url in
                                    AsyncImage(url: URL(string: url)) { image in
                                        image.resizable().scaledToFit()
                                    } placeholder: {
                                        Color.gray.opacity(0.3)
                                    }
                                    .frame(width: 200, height: 400)
                                    .cornerRadius(10)
                                }
                            }
                        }
                    }

                    Divider()

                    if let tintColor = app.tintColor {
                        Text("Tint Color: \(tintColor)")
                            .font(.headline)
                    }
                }
                .padding()
            }
        }
        .navigationTitle(app.name)
    }
}
