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
            VStack(alignment: .leading, spacing: 16) {
                // App Icon
                AsyncImage(url: URL(string: app.iconURL)) { image in
                    image.resizable()
                } placeholder: {
                    Color.gray.opacity(0.3)
                }
                .frame(width: 100, height: 100)
                .cornerRadius(20)
                .padding(.top)
                
                // App Name and Developer
                VStack(alignment: .leading) {
                    Text(app.name)
                        .font(.largeTitle)
                        .bold()
                    Text("by \(app.developerName)")
                        .font(.title3)
                        .foregroundColor(.gray)
                }
                .padding(.horizontal)
                
                // App Description
                if !app.localizedDescription.isEmpty {
                    Text("Description")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    Text(app.localizedDescription)
                        .font(.body)
                        .padding(.horizontal)
                }
                
                // Screenshots
                if let screenshotURLs = app.screenshotURLs, !screenshotURLs.isEmpty {
                    Text("Screenshots")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    ScrollView(.horizontal, showsIndicators: true) {
                        HStack(spacing: 12) {
                            ForEach(screenshotURLs, id: \.self) { url in
                                AsyncImage(url: URL(string: url)) { image in
                                    image.resizable()
                                } placeholder: {
                                    Color.gray.opacity(0.3)
                                }
                                .frame(width: 250, height: 150)
                                .cornerRadius(10)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .navigationTitle(app.name)
        }
    }
}

