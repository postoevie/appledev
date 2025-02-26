//
//  FetchCoinsDataUseCase.swift
//  CryptoTracker
//
//  Created by Igor Postoev on 25.2.25..
//

import Foundation
import Combine

final class FetchCoinsDataUseCase: FetchCoinsDataUseCaseType {
    
    private var timer: Timer?
    private var currentTask: Task<Void, Never>?
    
    private var coinNames: [String] = []
    @Published private var coinData: [CoinData] = []
    private var subscriptions: [AnyCancellable] = []
    
    private let fireInterval: Double
    private let fetchService: FetchCoinDataServiceType
    
    init(fireInterval: Double,
         fetchService: FetchCoinDataServiceType) {
        self.fireInterval = fireInterval
        self.fetchService = fetchService
    }
    
    func start() {
        Task {
            try await updateCoinsNames()
            try await updatePrices()
            await MainActor.run {
                timer = Timer.scheduledTimer(timeInterval: fireInterval,
                                             target: self,
                                             selector: #selector(timerFired),
                                             userInfo: nil,
                                             repeats: true)
            }
        }
    }
    
    func cancel() {
        timer?.invalidate()
        currentTask?.cancel()
        currentTask = nil
    }
    
    func subscribe(_ responder: FetchCoinDataUseCaseResponder) {
        $coinData
            .removeDuplicates()
            .sink { [weak responder] data in
                responder?.coinsDataFetchUseCaseCompleted(data: data)
            }
            .store(in: &subscriptions)
    }
    
    func subscribeStrong(_ responder: FetchCoinDataUseCaseResponder) {
        $coinData
            .removeDuplicates()
            .sink { data in
                responder.coinsDataFetchUseCaseCompleted(data: data)
            }
            .store(in: &subscriptions)
    }
    
    @objc func timerFired() {
        currentTask?.cancel()
        currentTask = Task {
            do {
                try await updatePrices()
            } catch {
                print(error)
            }
        }
    }
    
    private func updateCoinsNames() async throws {
        coinNames = try await fetchService.fetchCoinsList()
    }
    
    private func updatePrices() async throws {
        // Fetch coins data from web.
        let coins =
        try await withThrowingTaskGroup(of: CoinData.self) { group in
            for coinName in coinNames {
                group.addTask {
                    let price = try await self.fetchService.fetchCoinPrice(coinName: coinName)
                    
                    try Task.checkCancellation()
                    
                    return CoinData(name: coinName, price: price)
                }
            }
            // No need to group.waitForAll(). Intentionally cancel the whole group if any task throws.
            return try await group.reduce([CoinData](), { $0 + [$1] })
        }
        
        try Task.checkCancellation()
        
        coinData = coins
    }
    
    deinit {
        timer?.invalidate()
    }
}

