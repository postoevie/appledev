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

class AppDelegate: NSObject, UIApplicationDelegate, ObservableObject {
    
    // This gives us access to the methods from our main app code inside the app delegate

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // This is where we register this device to recieve push notifications from Apple
        // All this function does is register the device with APNs, it doesn't set up push notifications by itself
        
        // https://developer.apple.com/documentation/usernotifications/registering-your-app-with-apns
        application.registerForRemoteNotifications()
        
        // Setting the notification delegate
        UNUserNotificationCenter.current().delegate = self
        
        return true
    }
    
    func application(_ application: UIApplication,
                       didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Once the device is registered for push notifications Apple will send the token to our app and it will be available here.
        // This is also where we will forward the token to our push server
        // If you want to see a string version of your token, you can use the following code to print it out
        let stringifiedToken = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print("stringifiedToken:", stringifiedToken)
    }
    
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError
                     error: Error) {
        print("Fail registering in APN, \(error.localizedDescription)")
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        print("App will be terminated")
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    // This function lets us do something when the user interacts with a notification
    // like log that they clicked it, or navigate to a specific screen
    nonisolated func userNotificationCenter(_ center: UNUserNotificationCenter,
                                            didReceive response: UNNotificationResponse) async {
            print("Got notification title: ", response.notification.request.content.title)
    }
    
    // This function allows us to view notifications in the app even with it in the foreground
    nonisolated func userNotificationCenter(_ center: UNUserNotificationCenter,
                                            willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        // These options are the options that will be used when displaying a notification with the app in the foreground
        // for example, we will be able to display a badge on the app a banner alert will appear and we could play a sound
        return [.badge, .banner, .list, .sound]
    }
    
    // Use this method to process incoming remote notifications. The system calls this method when your app is running in the foreground or background
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable : Any]) async -> UIBackgroundFetchResult {
        
        return .newData
    }
}

@main
struct CryptoTrackerApp: App {
    
    @Environment(\.scenePhase) var scenePhase
    
    // https://developer.apple.com/documentation/swiftui/uiapplicationdelegateadaptor
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    
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
