//
//  CryptoTrackerApp.swift
//  CryptoTracker
//
//  Created by Igor Postoev on 18.2.25..
//

import SwiftUI
import SwiftData

@main
struct CryptoTrackerApp: App {
    
    var modelContainer: ModelContainer? = try? ModelContainer(for: Coin.self)
    
    var body: some Scene {
        WindowGroup {
            if let modelContainer {
                CoinsListAssembly().build(modelContainer: modelContainer)
            }
        }
    }
}
