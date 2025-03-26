//
//  FetchCoinsDataUseCase.swift
//  CryptoTracker
//
//  Created by Igor Postoev on 25.2.25..
//

import Foundation
import Combine
import Dispatch

// https://developer.apple.com/forums/thread/722411
/*
 A run loop is an event source dispatching mechanism. When you run it, it expects to block the calling thread for arbitrary amounts of time. If you call it from an async function, the calling thread is one of the threads from Swift concurrency’s cooperative thread pool.
 */

final class FetchCoinsDataUseCase: @unchecked Sendable, FetchCoinsDataUseCaseType, NetworkAvailabilityReponder {
    
    //private var updatePricesTimer: Timer? // Regularly causes prices update
    private var updatePricesTimer: DispatchSourceTimer? // Regularly causes prices update
    private var updatePricesTask: Task<Void, Never>? // Current prices updating task
    
    private var coinNames: [String] = []
    @Published private var coinData: [CoinData] = []
    
    private var subscriptions: [AnyCancellable] = []
    private var isRunning: Bool = false
    private var isStarted: Bool = false
    
    private let useCaseQueue = DispatchQueue(label: "cryptotest.concurrent")
    
    private let tickInterval: Double
    private let remoteDataService: CoinDataServiceRemoteType
    private let localDataService: CoinDataServiceLocalType
    private let networkAvailabilityService: NetworkAvailabilityServiceType
    
    init(tickInterval: Double,
         remoteDataService: CoinDataServiceRemoteType,
         localDataService: CoinDataServiceLocalType,
         networkAvailabilityService: NetworkAvailabilityServiceType) {
        self.tickInterval = tickInterval
        self.remoteDataService = remoteDataService
        self.localDataService = localDataService
        self.networkAvailabilityService = networkAvailabilityService
    }
    
    func start() {
        useCaseQueue.async {
            
            // No need to start or continue use case which is being invoked
            guard !self.isRunning else {
                return
            }
            self.isRunning = true
            
            if let updatePricesTimer = self.updatePricesTimer,
               updatePricesTimer.isCancelled == false {
                updatePricesTimer.resume()
                return
            }
            
            // Run once
            guard !self.isStarted else {
                return
            }
            self.isStarted = true
            
            // Initial start of the use case invocation
            self.networkAvailabilityService.start()
            Task {
                self.coinNames = try await self.remoteDataService.fetchCoinsList()
                self.coinData = try await self.localDataService.getItems()
            }
        }
    }
    
    func cancel() {
        useCaseQueue.async {
            self.isRunning = false
            self.updatePricesTimer?.suspend()
            self.updatePricesTask?.cancel()
            self.updatePricesTask = nil
        }
    }
    
    func subscribe(_ responder: FetchCoinDataUseCaseResponder) {
        $coinData
            .receive(on: useCaseQueue)
            .removeDuplicates()
            .sink { [weak responder] data in
                responder?.coinsDataFetchUseCaseCompleted(data: data)
            }
            .store(in: &subscriptions)
    }
    
    @objc func timerFired() {
        self.updatePricesTask?.cancel()
        self.updatePricesTask = Task {
            do {
                try await self.updatePrices()
            } catch {
                print("Update prices error \(error)")
            }
        }
    }
    
    /// Update price for each coin in coinNames[]
    private func updatePrices() async throws {
        // Fetch coins data from web.
        let coins =
        try await withThrowingTaskGroup(of: CoinData.self) { group in
            for coinName in coinNames {
                group.addTask {
                    let price = try await self.remoteDataService.fetchCoinPrice(coinName: coinName)
                    
                    try Task.checkCancellation()
                    
                    return CoinData(name: coinName, price: price)
                }
            }
            // No need to group.waitForAll(). Intentionally cancel the whole group if any task throws.
            return try await group.reduce([CoinData](), { $0 + [$1] })
        }
        
        try Task.checkCancellation()
        
        try await localDataService.save(coinItems: coins)
        
        self.coinData = try await localDataService.getItems()
    }
    
    // MARK: NetworkAvailabilityReponder
    
    func networkAvailabilityStatusChanged(status: NetStatus) {
        useCaseQueue.async {
            if status == .satisfied {
                // https://stackoverflow.com/questions/38164120/why-would-a-scheduledtimer-fire-properly-when-setup-outside-a-block-but-not-w
                let timer = DispatchSource.makeTimerSource(queue: self.useCaseQueue)
                timer.setEventHandler { [weak self] in
                    self?.timerFired()
                }
                timer.schedule(deadline: .now(), repeating: self.tickInterval)
                timer.resume()
                self.updatePricesTimer = timer
            } else {
                self.isRunning = false
                self.updatePricesTimer?.cancel()
                self.updatePricesTask?.cancel()
            }
        }
    }
    
    deinit {
        updatePricesTimer?.cancel()
    }
}

