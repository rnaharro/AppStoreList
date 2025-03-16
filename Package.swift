// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "DAAppsViewController",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v16) // Requires iOS 16 for modern SwiftUI and StoreKit features
    ],
    products: [
        .library(
            name: "DAAppsViewController",
            targets: ["DAAppsViewController"]
        ),
    ],
    targets: [
            .target(
                name: "DAAppsViewController",
                path: ".",
                exclude: ["DAAppsViewController/DAAppsViewControllerApp.swift"],
                sources: [
                    "DAAppsViewController/AppObject.swift",
                    "DAAppsViewController/AppStoreList.swift",
                    "DAAppsViewController/AppStoreViewModel.swift",
                ],
                resources: [
                    .process("DAAppsViewController/Resources")
                ]
            )
        ]
)
