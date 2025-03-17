//
//  AppStoreViewModel.swift
//  DAAppsViewControllerExample
//
//  Created by Ricardo Naharro on 15/3/25.
//  Copyright 2025 Daniel Amitay. All rights reserved.
//

import SwiftUI
import StoreKit

@MainActor
public class AppStoreViewModel: ObservableObject {
    @Published private(set) var apps: [AppObject] = []
    @Published private(set) var isLoading = false
    
    var compatibleApps: [AppObject] {
        apps.filter { $0.isCompatible }
    }
    
    func loadApps(with path: String) async throws {
        isLoading = true
        defer { isLoading = false }
        
        var urlString = "https://itunes.apple.com/" + path
        urlString += "&entity=software"
        
        if let languageCode = Locale.current.language.languageCode?.identifier {
            urlString += "&l=\(languageCode)"
        }
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.timeoutInterval = 20
        request.cachePolicy = .returnCacheDataElseLoad
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let response = try JSONDecoder().decode(AppStoreResponse.self, from: data)
        
        self.apps = response.results.compactMap { result in
            try? AppObject(from: result.asDictionary)
        }
    }
    
    // Added for preview support
    public func setApps(_ apps: [AppObject]) {
        self.apps = apps
    }
    
    func loadApps(forArtistId artistId: Int) async throws {
        try await loadApps(with: "lookup?id=\(artistId)")
    }
    
    func loadApps(forAppIds appIds: [Int]) async throws {
        let idsString = appIds.map(String.init).joined(separator: ",")
        try await loadApps(with: "lookup?id=\(idsString)")
    }
    
    func loadApps(forBundleIds bundleIds: [String]) async throws {
        let bundleString = bundleIds.joined(separator: ",")
        try await loadApps(with: "lookup?bundleId=\(bundleString)")
    }
    
    func loadApps(forSearchTerm searchTerm: String) async throws {
        guard let escapedTerm = searchTerm.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            throw URLError(.badURL)
        }
        try await loadApps(with: "search?term=\(escapedTerm)")
    }
    
    func presentApp(_ app: AppObject, affiliateToken: String?, campaignToken: String?) async {
        var parameters: [String: Any] = [
            SKStoreProductParameterITunesItemIdentifier: String(app.appId)
        ]
        
        if let affiliateToken {
            parameters[SKStoreProductParameterAffiliateToken] = affiliateToken
            if let campaignToken {
                parameters[SKStoreProductParameterCampaignToken] = campaignToken
            }
        }
        
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return
        }
        
        do {
            try await SKStoreProductViewController.presentInScene(scene, parameters: parameters)
        } catch {
            if let url = URL(string: "itms-apps://itunes.apple.com/app/id\(app.appId)?mt=8") {
                await UIApplication.shared.open(url)
            }
        }
    }
}

private struct AppStoreResponse: Decodable {
    let results: [AppStoreResult]
    
    struct AppStoreResult: Decodable {
        let kind: String?
        let bundleId: String?
        let trackName: String?
        let genres: [String]?
        let trackId: Int?
        let artistId: Int?
        let minimumOsVersion: String?
        let formattedPrice: String?
        let artworkUrl100: String?
        let artworkUrl512: String?
        let features: [String]?
        let averageUserRating: Float?
        let userRatingCount: Int?
        let screenshotUrls: [String]?
        let ipadScreenshotUrls: [String]?
        
        var asDictionary: [String: Any] {
            var dict: [String: Any] = [:]
            if let kind { dict["kind"] = kind }
            if let bundleId { dict["bundleId"] = bundleId }
            if let trackName { dict["trackName"] = trackName }
            if let genres { dict["genres"] = genres }
            if let trackId { dict["trackId"] = trackId }
            if let artistId { dict["artistId"] = artistId }
            if let minimumOsVersion { dict["minimumOsVersion"] = minimumOsVersion }
            if let formattedPrice { dict["formattedPrice"] = formattedPrice }
            if let artworkUrl100 { dict["artworkUrl100"] = artworkUrl100 }
            if let artworkUrl512 { dict["artworkUrl512"] = artworkUrl512 }
            if let features { dict["features"] = features }
            if let averageUserRating { dict["averageUserRating"] = averageUserRating }
            if let userRatingCount { dict["userRatingCount"] = userRatingCount }
            if let screenshotUrls { dict["screenshotUrls"] = screenshotUrls }
            if let ipadScreenshotUrls { dict["ipadScreenshotUrls"] = ipadScreenshotUrls }
            return dict
        }
    }
}

private extension SKStoreProductViewController {
    static func presentInScene(_ scene: UIWindowScene, parameters: [String: Any]) async throws {
        let controller = SKStoreProductViewController()
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            controller.loadProduct(withParameters: parameters) { result, error in
                if let error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: ())
                }
            }
        }
        
        await MainActor.run {
            scene.keyWindow?.rootViewController?.present(controller, animated: true)
        }
    }
}
