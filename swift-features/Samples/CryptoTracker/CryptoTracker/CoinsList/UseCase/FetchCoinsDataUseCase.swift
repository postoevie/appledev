//
//  FetchCoinsDataUseCase.swift
//  CryptoTracker
//
//  Created by Igor Postoev on 25.2.25..
//

import Foundation
import Combine
import Network

// TODO: Update tests, inversion of networkMonitor

final class FetchCoinsDataUseCase: FetchCoinsDataUseCaseType {
    
    private var timer: Timer?
    private var updatePricesTask: Task<Void, Never>?
    
    private var netStatus: NWPath.Status?
    private let networkMonitor = NWPathMonitor()
    private let networkMonitorQueue = DispatchQueue(label: "NetworkMonitor")
    
    private var coinNames: [String] = []
    @Published private var coinData: [CoinData] = []
    
    private var subscriptions: [AnyCancellable] = []
    
    private let fireInterval: Double
    private let remoteDataService: RemoteCoinDataServiceType
    private let localDataService: LocalCoinDataServiceType
    
    init(fireInterval: Double,
         remoteDataService: RemoteCoinDataServiceType,
         localDataService: LocalCoinDataServiceType) {
        self.fireInterval = fireInterval
        self.remoteDataService = remoteDataService
        self.localDataService = localDataService
        
        self.networkMonitor.pathUpdateHandler = { path in
            guard self.netStatus != path.status else {
                return
            }
            self.netStatus = path.status
            if path.status == .satisfied {
                Task {
                    try await self.updateCoinsNames()
                    try await self.updatePrices()
                    await MainActor.run {
                        self.timer = Timer.scheduledTimer(timeInterval: fireInterval,
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
    }
    
    func start() {
        Task {
            self.coinData = try await localDataService.getItems()
            self.networkMonitor.start(queue: networkMonitorQueue)
        }
    }
    
    func cancel() {
        timer?.invalidate()
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
    
    private func updateCoinsNames() async throws {
        coinNames = try await remoteDataService.fetchCoinsList()
    }
    
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
        timer?.invalidate()
    }
}

