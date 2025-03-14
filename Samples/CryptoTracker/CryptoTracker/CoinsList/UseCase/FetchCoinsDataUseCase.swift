//
//  FetchCoinsDataUseCase.swift
//  CryptoTracker
//
//  Created by Igor Postoev on 25.2.25..
//

import Foundation
import Combine

final class FetchCoinsDataUseCase: FetchCoinsDataUseCaseType, NetworkAvailabilityReponder {
    
    private var updatePricesTimer: Timer? // Regularly causes prices update
    private var updatePricesTask: Task<Void, Never>? // Current prices updating task
    
    private var coinNames: [String] = []
    @Published private var coinData: [CoinData] = []
    
    private var subscriptions: [AnyCancellable] = []
    
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
        Task {
            self.coinData = try await localDataService.getItems()
            self.networkAvailabilityService.start()
        }
    }
    
    func cancel() {
        updatePricesTimer?.invalidate()
        updatePricesTask?.cancel()
    }
    
    func subscribe(_ responder: FetchCoinDataUseCaseResponder) {
        $coinData
            .removeDuplicates()
            .sink { [weak responder] data in
                responder?.coinsDataFetchUseCaseCompleted(data: data)
            }
            .store(in: &subscriptions)
    }
    
    @objc func timerFired() {
        updatePricesTask?.cancel()
        updatePricesTask = Task {
            do {
                try await updatePrices()
            } catch {
                print(error)
            }
        }
    }
    
    // MARK: NetworkAvailabilityReponder
    
    func networkAvailabilityStatusChanged(status: NetStatus) {
        if status == .satisfied {
            Task {
                self.coinNames = try await remoteDataService.fetchCoinsList()
                try await self.updatePrices()
                await MainActor.run {
                    self.updatePricesTimer = Timer.scheduledTimer(timeInterval: tickInterval,
                                                                  target: self,
                                                                  selector: #selector(self.timerFired),
                                                                  userInfo: nil,
                                                                  repeats: true)
                }
            }
        } else {
            self.cancel()
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
        
        coinData = try await localDataService.getItems()
    }
    
    deinit {
        updatePricesTimer?.invalidate()
    }
}

