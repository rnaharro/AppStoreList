// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "AppStoreList",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v16) // Requires iOS 16 for modern SwiftUI and StoreKit features
    ],
    products: [
        .library(
            name: "AppStoreList",
            targets: ["AppStoreList"]
        ),
    ],
    targets: [
            .target(
                name: "AppStoreList",
                path: ".",
                exclude: ["AppStoreList/AppStoreListDemoApp.swift"],
                sources: [
                    "AppStoreList/AppObject.swift",
                    "AppStoreList/AppStoreList.swift",
                    "AppStoreList/AppStoreViewModel.swift",
                ],
                resources: [
                    .process("AppStoreList/Resources")
                ]
            )
        ]
)
