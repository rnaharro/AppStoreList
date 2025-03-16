//
//  AppStoreList.swift
//  DAAppsViewControllerExample
//
//  Created by Ricardo Naharro on 15/3/25.
//  Copyright 2025 Daniel Amitay. All rights reserved.
//

import SwiftUI
import StoreKit

public struct AppStoreList: View {
    @StateObject var viewModel = AppStoreViewModel()
    let title: String?
    let affiliateToken: String?
    let campaignToken: String?
    let artistId: Int?
    let onAppViewed: ((Int) -> Void)?

    public init(
        title: String? = nil,
        affiliateToken: String? = nil,
        campaignToken: String? = nil,
        artistId: Int? = nil,
        onAppViewed: ((Int) -> Void)? = nil
    ) {
        self.title = title
        self.affiliateToken = affiliateToken
        self.campaignToken = campaignToken
        self.onAppViewed = onAppViewed
        self.artistId = artistId
    }

    public var body: some View {
        List(viewModel.compatibleApps) { app in
            AppStoreRow(app: app)
                .onTapGesture {
                    Task {
                        await viewModel.presentApp(app,
                                                   affiliateToken: affiliateToken,
                                                   campaignToken: campaignToken)
                        onAppViewed?(app.appId)
                    }
                }
                .listRowBackground(Color(.systemBackground))
        }
        .listStyle(.plain)
        .navigationTitle(title ?? NSLocalizedString("Results", comment: ""))
        .overlay {
            if viewModel.isLoading {
                ProgressView(NSLocalizedString("Loading...", comment: ""))
            }
        }
        .task {
            if let artistId {
                try? await viewModel.loadApps(forArtistId: artistId)
            }
        }
    }
}

private struct AppStoreRow: View {
    let app: AppObject

    var body: some View {
        HStack(spacing: 12) {
            // Icono con sombra
            AsyncImage(url: app.iconURL) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .mask(RoundedRectangle(cornerRadius: 12))
                    .overlay {
                        Color.black.opacity(0.1)
                            .mask(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(lineWidth: 1)
                            )
                    }
            } placeholder: {
                Color.gray.opacity(0.2)
            }
            .frame(width: 64, height: 64)

            // Información de la app
            VStack(alignment: .leading, spacing: 4) {
                Text(app.name)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.primary)
                    .lineLimit(2)

                Text(app.genre)
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)

                // Estrellas y botón
                HStack(spacing: 4) {
                    if app.userRatingCount > 0 {
                        HStack(alignment: .center) {
                            StarsView(rating: app.userRating)
                                .frame(height: 10)
                            Text("(\(app.userRatingCount.formatted()))")
                                .font(.system(size: 14))
                                .foregroundColor(.secondary)
                        }
                    } else {
                        Text(NSLocalizedString("No Ratings", comment: ""))
                            .font(.system(size: 14))
                            .foregroundColor(.secondary)
                    }

                    Spacer()

                    // Botón "Get"
                    Button(action: {}) {
                        Text(app.formattedPrice)
                            .font(.system(size: 12, weight: .bold))
                            .frame(width: 60, height: 26)
                            .foregroundColor(.accentColor)
                            .overlay(
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(Color.accentColor, lineWidth: 1)
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.vertical, 6)
        .background(Color(.systemBackground))
    }
}

private struct StarsView: View {
    let rating: Float
    
    var body: some View {
        HStack(spacing: 2) {
            ForEach(0..<5) { index in
                Image(systemName: starImageName(for: index))
                    .foregroundStyle(.secondary)
            }
        }
    }
    
    private func starImageName(for index: Int) -> String {
        let threshold = Float(index) + 0.5
        if Float(index) < rating {
            return threshold > rating ? "star.leadinghalf.filled" : "star.fill"
        }
        return "star"
    }
}

#Preview {
    NavigationView {
        AppStoreList(title: "Sample Apps", artistId: 383673904)
    }
}
