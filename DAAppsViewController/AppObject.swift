//
//  AppObject.swift
//  DAAppsViewControllerExample
//
//  Created by Ricardo Naharro on 15/3/25.
//  Copyright © 2025 Daniel Amitay. All rights reserved.
//

import Foundation
import UIKit

public struct AppObject: Identifiable, Equatable {
    public let id: Int // This will be the appId
    public let artistId: Int
    public let bundleId: String
    public let name: String
    public let genre: String
    public let appId: Int
    public let isUniversal: Bool
    public let minimumOsVersion: String
    public let formattedPrice: String
    public let iconURL: URL
    public let userRating: Float
    public let userRatingCount: Int
    public let isCompatible: Bool
    
    public init(from result: [String: Any]) throws {
        guard let kind = result["kind"] as? String,
              kind == "software",
              let bundleId = result["bundleId"] as? String,
              let name = result["trackName"] as? String,
              let genres = result["genres"] as? [String],
              let appId = result["trackId"] as? Int,
              let artistId = result["artistId"] as? Int,
              let minimumOsVersion = result["minimumOsVersion"] as? String,
              let formattedPrice = result["formattedPrice"] as? String
        else {
            throw AppError.invalidData
        }
        
        self.id = appId
        self.bundleId = bundleId
        self.name = name
        self.genre = genres[0]
        self.appId = appId
        self.artistId = artistId
        
        let features = result["features"] as? [String] ?? []
        self.isUniversal = features.contains("iosUniversal")
        self.minimumOsVersion = minimumOsVersion
        // Updated formattedPrice logic to handle FREE -> Get case
        var price = formattedPrice.uppercased()
        if price == "FREE" {
            price = "Get"
        }
        self.formattedPrice = price
        
        // Prefer artworkUrl512 over artworkUrl100 as in original code
        let artworkUrl512 = result["artworkUrl512"] as? String
        let artworkUrl100 = result["artworkUrl100"] as? String
        guard let iconUrlString = (artworkUrl512?.isEmpty == false ? artworkUrl512 : artworkUrl100),
              let iconURL = URL(string: iconUrlString) else {
            throw AppError.invalidIconURL
        }
        self.iconURL = iconURL
        
        self.userRating = (result["averageUserRating"] as? Float) ?? 0.0
        self.userRatingCount = (result["userRatingCount"] as? Int) ?? 0
        
        // Compatibility check
        let systemVersion = UIDevice.current.systemVersion
        var isCompatible = false
        
        if minimumOsVersion.compare(systemVersion, options: .numeric) != .orderedDescending {
            if isUniversal {
                isCompatible = true
            } else {
                switch UIDevice.current.userInterfaceIdiom {
                case .phone:
                    let screenshotUrls = result["screenshotUrls"] as? [String] ?? []
                    isCompatible = !screenshotUrls.isEmpty
                case .pad:
                    let screenshotUrls = result["screenshotUrls"] as? [String] ?? []
                    let ipadScreenshotUrls = result["ipadScreenshotUrls"] as? [String] ?? []
                    isCompatible = !screenshotUrls.isEmpty || !ipadScreenshotUrls.isEmpty
                default:
                    isCompatible = true
                }
            }
        }
        self.isCompatible = isCompatible
    }
}

public enum AppError: Error {
    case invalidData
    case invalidIconURL
}

// MARK: - Equatable Implementation
extension AppObject {
    public static func == (lhs: AppObject, rhs: AppObject) -> Bool {
        if lhs.appId != rhs.appId { return false }
        if lhs.artistId != rhs.artistId { return false }
        return true
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(appId)
        hasher.combine(artistId)
    }
}
