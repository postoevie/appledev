//
//  CryptoTrackerApp.swift
//  CryptoTracker
//
//  Created by Igor Postoev on 18.2.25..
//

import SwiftUI
import SwiftData
import BackgroundTasks

// Malloc error on thread sanitizer on https://stackoverflow.com/questions/64126942/malloc-nano-zone-abandoned-due-to-inability-to-preallocate-reserved-vm-space

@main
struct CryptoTrackerApp: App {
    
    // https://developer.apple.com/documentation/swiftui/uiapplicationdelegateadaptor
    // @UIApplicationDelegateAdaptor private var appDelegate: MyAppDelegate
    
    @Environment(\.scenePhase) var scenePhase
    
    var modelContainer: ModelContainer? = try? ModelContainer(for: Coin.self)
    
    var body: some Scene {
        WindowGroup {
            if let modelContainer {
                CoinsListSwiftDataAssembly().build(modelContainer: modelContainer)
            }
        }
        .onChange(of: scenePhase) { _, newPhase in
            if newPhase == .active {
                Task {
                    let center = UNUserNotificationCenter.current()
                    do {
                        try await center.requestAuthorization(options: [.alert, .sound, .badge])
                    } catch {
                        // Handle the error here.
                    }
                }
            }
            if newPhase == .background {
                print("phase changed to background in App")
                scheduleRefreshCoins()
            }
        }
        .backgroundTask(.appRefresh("com.cryptotracker.refreshcoins")) {
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
            print("Refresh background task shceduling error \(error)")
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
        let content = UNMutableNotificationContent()
        content.title = "Condition Met!"
        content.body = "You have reached your target price!"
        content.sound = .default
        let trigger = UNCalendarNotificationTrigger(dateMatching: DateComponents(second: 5), repeats: false)
        let uuidSrting = UUID().uuidString
        let notificationRequest = UNNotificationRequest(identifier: uuidSrting,
                                                        content: content,
                                                        trigger: trigger)
        do {
            try await UNUserNotificationCenter.current().add(notificationRequest)
        } catch {
            print("Notification failed: \(error)")
        }
    }
}
