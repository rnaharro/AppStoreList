//
//  AppStoreListDemoApp.swift
//  AppStoreList
//
//  Created by Ricardo Naharro on 15/3/25.
//

import SwiftUI

@main
struct AppStoreListDemoApp: App {
    var artistId: Int = 383673904
    var body: some Scene {
        WindowGroup {
            NavigationView {
                AppStoreList(title: "Sample Apps", artistId: artistId)
            }
        }
    }
}

#Preview {
    NavigationView {
        AppStoreList(title: "Sample Apps", artistId: 383673904)
    }
}

