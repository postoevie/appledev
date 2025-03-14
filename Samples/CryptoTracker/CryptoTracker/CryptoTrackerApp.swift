//
//  CryptoTrackerApp.swift
//  CryptoTracker
//
//  Created by Igor Postoev on 18.2.25..
//

import SwiftUI
import SwiftData
import BackgroundTasks

@main
struct CryptoTrackerApp: App {
    
    // https://developer.apple.com/documentation/swiftui/uiapplicationdelegateadaptor
    // @UIApplicationDelegateAdaptor private var appDelegate: MyAppDelegate
    
    @Environment(\.scenePhase) private var scenePhase
    
    var modelContainer: ModelContainer? = try? ModelContainer(for: Coin.self)
    
    var body: some Scene {
        WindowGroup {
            if let modelContainer {
                //CoinsListAssembly().build(modelContainer: modelContainer)
                CoinsListSwiftDataAssembly().build(modelContainer: modelContainer)
            }
        }
        .onChange(of: scenePhase) { _, newState in
            if newState == .background {
                scheduleRefreshCoins()
            }
        }
        .backgroundTask(.appRefresh("com.cryptotracker.refreshcoins")) {
            await scheduleRefreshCoins()
            do {
                try await refreshCoins()
                if try await checkIfMetCondition() {
                    try await notifyConditionMet()
                }
            } catch {
                print("Tokens not refreshed \(error)")
            }
        }
    }
    
    func scheduleRefreshCoins() {
        let request = BGAppRefreshTaskRequest(identifier: "com.cryptotracker.refreshcoins")
        request.earliestBeginDate = Date().addingTimeInterval(60)
        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("Refresh background task shceduling error")
        }
    }
    
    nonisolated func refreshCoins() async throws {
        let coinData = try await withThrowingTaskGroup(of: CoinData.self) { group in
            let remoteService = FetchCoinDataNetworkService()
            for coinName in try await remoteService.fetchCoinsList() {
                group.addTask {
                    let price = try await remoteService.fetchCoinPrice(coinName: coinName)
                    
                    try Task.checkCancellation()
                    
                    return CoinData(name: coinName, price: price)
                }
            }
            // No need to group.waitForAll(). Intentionally cancel the whole group if any task throws.
            return try await group.reduce([CoinData](), { $0 + [$1] })
        }
        if let localModelContainer = try? ModelContainer(for: Coin.self) {
            try await CoinDataPersistService(modelContainer: localModelContainer).save(coinItems: coinData)
        }
    }
    
    func checkIfMetCondition() async throws -> Bool {
        let localModelContainer = try ModelContainer(for: Coin.self)
        let coinData = try await CoinDataPersistService(modelContainer: localModelContainer).getItems()
        return coinData.contains { $0.price >= 300 }
    }
    
    func notifyConditionMet() async throws {
        return;
        let notificationRequest = UNNotificationRequest(identifier: "request",
                                                        content: UNNotificationContent(),
                                                        trigger: nil)
        do {
            try await UNUserNotificationCenter.current().add(notificationRequest)
        } catch {
            print("Notification failed: \(error)")
        }
    }
}
